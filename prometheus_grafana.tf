resource "kubernetes_namespace" "selfhosted_prometheus_grafana_namespace" {
  count = (var.selfhosted_prometheus_grafana_enabled && var.selfhosted_prometheus_grafana_namespace != "kube-system") ? 1 : 0

  metadata {
    name = var.selfhosted_prometheus_grafana_namespace
  }
}
resource "helm_release" "selfhosted_prometheus_grafana_install" {
  count      = var.selfhosted_prometheus_grafana_enabled ? 1 : 0
  name       = var.selfhosted_prometheus_release_name
  namespace  = var.selfhosted_prometheus_grafana_namespace
  version    = var.selfhosted_prometheus_chart_version
  repository = var.selfhosted_prometheus_helm_chart_repo
  chart      = var.selfhosted_prometheus_helm_chart_name
  values = [
    yamlencode(var.selfhosted_prometheus_grafana_settings)
  ]
  depends_on = [kubernetes_namespace.selfhosted_prometheus_grafana_namespace]
}
