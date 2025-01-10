resource "helm_release" "kube_state_metrics" {
  
  name = "kube-state-metrics"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-state-metrics"
  namespace        = "kube-system"
  create_namespace = true
  version = "5.27.1"

set {
    name  = "Prometheus.monitor.namespace"
    value = "monitoring"
  }
}
