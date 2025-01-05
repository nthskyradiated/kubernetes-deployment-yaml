#!/bin/bash

# Update and upgrade system packages
sudo apt update -y && sudo apt upgrade -y

# Disable swap and configure system parameters for Kubernetes
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
sudo rm -f /swapfile
sudo systemctl daemon-reexec

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay && sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# Install necessary packages for containerd and Kubernetes
DEBIAN_FRONTEND=noninteractive sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates

# Install and configure containerd
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update -y

DEBIAN_FRONTEND=noninteractive sudo apt install -y containerd.io

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo sed -i '/sandbox_image/s|registry.k8s.io/pause:3.8|registry.k8s.io/pause:3.10|' /etc/containerd/config.toml
sudo systemctl restart containerd && sudo systemctl enable containerd

# Add Kubernetes repository and install the latest kubeadm, kubelet, and kubectl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update -y

DEBIAN_FRONTEND=noninteractive sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet

# Check hostname and proceed with kubeadm init only on the master node
if [[ "$(hostname)" == "controlplane01" ]]; then
    sudo kubeadm init --pod-network-cidr=10.244.0.0/16 \
    --service-cidr=10.96.0.0/16 \
    --control-plane-endpoint=192.168.1.211 \
    --skip-phases=addon/kube-proxy \
    --upload-certs | tee ~/kubeadm-init-output.txt
    # Configure kubectl for the master node
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    # Install Ciliium CNI
    helm repo add cilium https://helm.cilium.io/
    helm repo update
    helm install cilium cilium/cilium --version 1.17.0-rc.0 --namespace kube-system \
    --set ipam.operator.clusterPoolIPv4PodCIDRList=["10.244.0.0/16"] \
    --set ipam.mode='kubernetes' \
    --set enable-endpoint-routes="true" \
    --set k8s-service-cidr='10.96.0.0/16' \
    --set kubeProxyReplacement='true' \
    --set k8sServiceHost='192.168.1.211' \
    --set k8sServicePort='6443' \
    --set enable-host-reachable-services='true' \
    --set kubeProxyReplacementHealthzBindAddr='0.0.0.0:10256' \
    --set bpf.lbExternalClusterIP='true' \
    --set prometheus.enabled=true \
    --set operator.prometheus.enabled=true \
    --set envoy.prometheus.enabled=true \
    --set hubble.enabled=true \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true \
    
else
    echo "This is not the control plane node. Script execution ends here."
    exit 0
fi