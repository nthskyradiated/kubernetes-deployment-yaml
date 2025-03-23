resource "helm_release" "sealed_secrets" {
  name = "sealed-secrets"

  repository       = "oci://registry-1.docker.io/bitnamicharts/"
  chart            = "sealed-secrets"
  namespace        = "kube-system"
  create_namespace = true
  version          = "2.5.2"
}
