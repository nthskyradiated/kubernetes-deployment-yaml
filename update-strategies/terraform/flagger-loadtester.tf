resource "helm_release" "loadtester" {
  name = "loadtester"

  repository       = "https://flagger.app"
  chart            = "loadtester"
  namespace        = "flagger"
  create_namespace = true
  version          = "0.34.0"
}
