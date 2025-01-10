resource "helm_release" "k8s_dashboard" {
  name = "k8s-dashboard"

  repository       = "https://kubernetes.github.io/dashboard/"
  chart            = "kubernetes-dashboard"
  namespace        = "kubernetes-dashboard"
  create_namespace = true
  version          = "7.10.0"

}
