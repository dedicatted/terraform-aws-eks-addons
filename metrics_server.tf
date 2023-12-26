resource "kubernetes_namespace" "metrics_server_namespace" {
  count      = (var.metrics_server_enabled && var.metrics_server_namespace != "kube-system") ? 1 : 0

  metadata {
    name = var.metrics_server_namespace
  }
}

resource "helm_release" "metrics_server" {
  count  = var.metrics_server_enabled ? 1 : 0
  namespace        = var.metrics_server_namespace
  name       = "metrics-server"
  repository = var.metrics_server_helm_chart_repo
  chart      = var.metrics_server_helm_chart_name
  version    = var.metrics_server_helm_chart_version
  
  depends_on = [ kubernetes_namespace.metrics_server_namespace ]
}