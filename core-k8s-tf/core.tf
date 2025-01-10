data "kubectl_path_documents" "k8s_dashboard_rbac" {
  pattern = "./k8s-dashboard/*.yaml"
}

resource "kubectl_manifest" "k8s_dashboard_rbac" {
  for_each  = toset(data.kubectl_path_documents.k8s_dashboard_rbac.documents)
  yaml_body = each.value

  depends_on = [helm_release.k8s_dashboard]
}
