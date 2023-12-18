# install ingress-nginx
resource "helm_release" "ingress_nginx" {
  count  = var.ingress_nginx_enabled ? 1 : 0
  version          = var.ingress_nginx_version
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = var.ingress_nginx_namespace
  create_namespace = true
  set {
    name  = "controller.service.annotations.service.beta.kubernetes.io/aws-load-balancer-proxy-protocol"
    value = "*"
  }

  set {
    name  = "controller.service.annotations.service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout"
    value = "3600"
  }

  set {
    name  = "controller.service.annotations.service.beta.kubernetes.io/aws-load-balancer-backend-protocol"
    value = "tcp"
  }
}

data "kubernetes_service" "ingress_nginx_service" {
  count  = var.ingress_nginx_enabled ? 1 : 0
  depends_on = [helm_release.ingress_nginx]
  metadata {
    name      = "${helm_release.ingress_nginx.name}-controller"
    namespace = var.ingress_nginx_namespace
  }
}

data "ingress_nginx_route53_zone" "dns_zone" {
  count  = var.ingress_nginx_enabled ? 1 : 0
  name = var.ingress_nginx_route53_zone_name
}

resource "aws_route53_record" "rancher_cluster_ingress" {
  count  = var.ingress_nginx_enabled ? 1 : 0
  zone_id    = data.ingress_nginx_route53_zone.dns_zone.zone_id
  name       = var.ingress_nginx_route53_zone_name
  type       = "CNAME"
  records    = [data.kubernetes_service.ingress_nginx_service.load_balancer_ingress.0.hostname]
  ttl        = 300
}