
module "cert_manager_irsa_role" {
  count  = var.cert_manager_enabled ? 1 : 0
  source = "../../modules/iam-role-for-service-accounts-eks"

  role_name                     = var.cert_manager_irsa_role_name
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = var.cert_manager_hosted_zone_arn

  oidc_providers = {
    ex = {
      provider_arn               = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
      namespace_service_accounts = ["kube-system:cert-manager"]
    }
  }
}

resource "helm_release" "cert_manager" {
  count      = var.cert_manager_enabled ? 1 : 0
  name       = var.helm_chart_name
  chart      = var.helm_chart_release_name
  repository = var.helm_chart_repo
  version    = var.helm_chart_version
  namespace  = "kube-system"

  set {
    name  = "installCRDs"
    value = var.install_CRDs
  }

  set {
    name  = "serviceAccount.create"
    value = true
  }

  set {
    name  = "serviceAccount.name"
    value = "cert-manager"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.cert_manager_irsa_role[0].iam_role_arn
  }

  values = [
    yamlencode(var.settings)
  ]

}