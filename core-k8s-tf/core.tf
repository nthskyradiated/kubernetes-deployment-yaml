data "kubectl_path_documents" "k8s_dashboard_rbac" {
  pattern = "./k8s-dashboard/*.yaml"
}

resource "kubectl_manifest" "k8s_dashboard_rbac" {
  for_each  = toset(data.kubectl_path_documents.k8s_dashboard_rbac.documents)
  yaml_body = each.value

  depends_on = [helm_release.k8s_dashboard]
}


#data "kubectl_path_documents" "prometheus_node_exporter_podmonitor" {
#  pattern = "./node-exporter/*.yaml"
#}

#resource "kubectl_manifest" "prometheus_node_exporter_podmonitor" {
#  for_each  = toset(data.kubectl_path_documents.prometheus_node_exporter_podmonitor.documents)
#  yaml_body = each.value

#  depends_on = [helm_release.prometheus_node_exporter]
#}

data "kubectl_path_documents" "kube_state_metrics_svcmonitor" {
  pattern = "./k8s-state-metrics/*.yaml"
}

resource "kubectl_manifest" "kube_state_metrics_svcmonitor" {
  for_each  = toset(data.kubectl_path_documents.kube_state_metrics_svcmonitor.documents)
  yaml_body = each.value

  depends_on = [helm_release.kube_state_metrics]
}
