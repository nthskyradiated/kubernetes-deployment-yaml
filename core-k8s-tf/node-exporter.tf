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
    name  = "service.annotations.prometheus.io/scrape"
    value = true
  }
  set {
    name  = "service.annotations.prometheus.io/port"
    value = "9100"
  }
  set {
    name = "prometheus.monitor.enabled"
    value = true
  }
  set {
    name = "prometheus.monitor.namespace"
    value = "monitoring"
  }
  set {
    name = "podMonitor.enabled"
    value = true
  }
  set {
    name = "podMonitor.namespace"
    value = "monitoring"
  }
  set {
    name = "podMonitor.additionalLabels"
    value = {
      "prometheus" = "main"
    }
  }
}
