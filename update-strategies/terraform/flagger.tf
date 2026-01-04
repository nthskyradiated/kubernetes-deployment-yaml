resource "helm_release" "flagger" {
  name = "flagger"

  repository       = "https://flagger.app"
  chart            = "flagger"
  namespace        = "flagger"
  create_namespace = true
  version          = "1.40.0"

  set = [
  {
    name  = "crd.create"
    value = "false"
  },

   {
    name  = "meshProvider"
    value = "istio"
  },
  {
    name  = "metricsServer"
    value = "http://prometheus-operated.monitoring:9090"
  }

  ]

}
