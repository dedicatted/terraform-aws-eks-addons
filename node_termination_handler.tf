resource "kubernetes_namespace" "node_termination_handler_namespace" {
  count      = (var.node_termination_handler_enabled && var.node_termination_handler_namespace != "kube-system") ? 1 : 0

  metadata {
    name = var.node_termination_handler_namespace
  }
}
resource "helm_release" "node_termination_handler" {
  count      = var.node_termination_handler_enabled ? 1 : 0
  chart      = var.node_termination_handler_helm_chart_name
  namespace  = var.node_termination_handler_namespace
  name       = var.node_termination_handler_helm_release_name
  version    = var.node_termination_handler_helm_chart_version
  repository = var.node_termination_handler_helm_repo_url
  values = [
    yamlencode(var.settings)
  ]
}