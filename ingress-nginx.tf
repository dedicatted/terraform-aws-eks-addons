resource "kubernetes_namespace" "ingress_nginx_namespace" {
  count = (var.ingress_nginx_enabled && var.ingress_nginx_namespace != "kube-system") ? 1 : 0

  metadata {
    name = var.ingress_nginx_namespace
  }
}
# install ingress-nginx
resource "helm_release" "ingress_nginx" {
  count      = var.ingress_nginx_enabled ? 1 : 0
  version    = var.ingress_nginx_version
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = var.ingress_nginx_namespace

  set {
    name  = "controller.annotations.kubernetes\\.io/ingress\\.class"
    value = "alb"
  }
  set {
    name  = "controller.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"
    value = var.ingress_controller_type
  }
  values = [
    yamlencode(var.ingress_nginx_settings)
  ]
}