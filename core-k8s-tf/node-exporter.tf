# NOTE: Need prometheus CRD from ../update-strategies/terraform/
resource "helm_release" "prometheus_node_exporter" {
  name = "node-exporter"

  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus-node-exporter"
  namespace        = "monitoring"
  create_namespace = true
  version          = "4.43.1"

  set = [
  {
    name  = "service.portName"
    value = "node-exporter"
  },
  {
    name = "prometheus.podMonitor.enabled"
    value = true
  },
  {
    name = "prometheus.podMonitor.namespace"
    value = "monitoring"
  },
  {
    name  = "prometheus.podMonitor.additionalLabels.prometheus"
    value = "main"
  }
  ]
}
