################################################################################
# External-DNS Configuration
################################################################################

module "external_dns_irsa_role" {
  count  = var.external_dns_enabled ? 1 : 0
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                     = var.external_dns_irsa_role_name
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = [data.aws_route53_zone.this.arn]

  oidc_providers = {
    ex = {
      provider_arn               = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
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
  zoneType: public
txtOwnerId: ${data.aws_route53_zone.this.zone_id}
domainFilters[0]: ${var.route53_zone_name}
policy: sync
serviceAccount:
  create: true
  name: external-dns
  annotations:
    eks.amazonaws.com/role-arn: ${module.external_dns_irsa_role[0].iam_role_arn}
EOF
  ]
}