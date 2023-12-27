################################################################################
# External-DNS Configuration
################################################################################

module "external_dns_irsa_role" {
  count  = var.external_dns_enabled ? 1 : 0
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                     = var.external_dns_irsa_role_name
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = [data.aws_route53_zone.external_dns_zone_name[0].zone_id]

  oidc_providers = {
    ex = {
      provider_arn               = "arn:aws:iam::${data.aws_caller_identity.current.id}:oidc-provider/${local.provider_arn}"
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }
}
resource "helm_release" "external_dns" {
  count      = var.external_dns_enabled ? 1 : 0
  namespace  = "kube-system"
  repository = "https://charts.bitnami.com/bitnami"
  name       = "external-dns"
  chart      = "external-dns"
  version    = var.external_dns_chart_version
  wait       = true
  timeout    = "300"
  values = [<<EOF
provider: aws
aws:
  zoneType: ${var.external_dns_zone_type}
txtOwnerId: ${data.aws_route53_zone.external_dns_zone_name[0].zone_id}
domainFilters[0]: ${var.route53_zone_name}
policy: sync
serviceAccount:
  create: true
  name: external-dns
  annotations:
    eks.amazonaws.com/role-arn: ${module.external_dns_irsa_role[0].iam_role_arn}
EOF
  ]
  depends_on = [module.external_dns_irsa_role]
}
