resource "kubernetes_namespace" "rancher_namespace" {
  count = (var.rancher_enabled && var.rancher_namespace != "kube-system") ? 1 : 0

  metadata {
    name = var.rancher_namespace
  }
}

resource "helm_release" "rancher" {
  count      = var.rancher_enabled ? 1 : 0
  name       = "rancher"
  repository = var.rancher_repository
  chart      = var.rancher_chart_name
  version    = var.rancher_version
  namespace  = var.rancher_namespace
  timeout    = "300"
  set {
    name  = "hostname"
    value = var.rancher_domain
  }

  set {
    name  = "bootstrapPassword"
    value = var.rancher_bootstrapPassword
  }
  set {
    name  = "ingress.ingressClassName"
    value = "nginx"
  }
  depends_on = [kubernetes_namespace.rancher_namespace]
}