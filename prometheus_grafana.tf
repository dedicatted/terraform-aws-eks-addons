resource "kubernetes_namespace" "prometheus_grafana_namespace" {
  count = (var.prometheus_grafana_enabled && var.prometheus_grafana_namespace != "kube-system") ? 1 : 0

  metadata {
    name = var.prometheus_grafana_namespace
  }
}
resource "helm_release" "prometheus_grafana_install" {
  count      = var.prometheus_grafana_enabled ? 1 : 0
  name       = var.prometheus_release_name
  namespace  = var.prometheus_grafana_namespace
  version    = var.prometheus_chart_version
  repository = var.prometheus_helm_chart_repo
  chart      = var.prometheus_helm_chart_name
  values = [
    yamlencode(var.prometheus_grafana_settings)
  ]
  depends_on = [kubernetes_namespace.prometheus_namespace]
}
