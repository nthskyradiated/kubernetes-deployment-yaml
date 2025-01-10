resource "helm_release" "prometheus_node_exporter" {
  name = "node-exporter"

  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus-node-exporter"
  namespace        = "monitoring"
  create_namespace = true
  version          = "4.43.1"

  set {
    name  = "service.portName"
    value = "node-exporter"
  }
  set {
    name = "prometheus.podMonitor.enabled"
    value = true
  }
  set {
    name = "prometheus.podMonitor.namespace"
    value = "monitoring"
  }
set {
    name  = "prometheus.podMonitor.additionalLabels.prometheus"
    value = "main"
  }
}
