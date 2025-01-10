
## 1. Install Kubernetes Dashboard
```bash
# Add kubernetes-dashboard repository
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
# Deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
```


## 2. Apply Service Account and RBAC configuration files
```bash
kubectl apply -f k8sadmin-serviceaccount.yaml && kubectl apply -f admin-rbac.yaml
```
## 3. Expose Dashboard Proxy
```bash
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443
```
## 4. Access the Dashboard
dashboard address: https://localhost:8443

## 5. Generate Token for the dashboard
```bash
kubectl -n kube-system create token k8sadmin
```
