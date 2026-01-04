# NOTE: Need prometheus CRD from ../update-strategies/terraform/
resource "helm_release" "kube_state_metrics" {

  name = "kube-state-metrics"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-state-metrics"
  namespace        = "kube-system"
  create_namespace = true
  version = "5.27.1"

set = [
{
    name  = "prometheus.monitor.enabled"
    value = "true"
  },
 {
    name  = "prometheus.monitor.namespace"
    value = "monitoring"
  },
 {
    name  = "prometheus.monitor.additionalLabels.prometheus"
    value = "main"
  }

]

}
