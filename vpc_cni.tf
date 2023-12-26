module "vpc_cni_ipv4_irsa_role" {
  count      = var.vpc_cni_enabled ? 1 : 0
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = var.vpc_cni_irsa_role_name
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    ex = {
      provider_arn               = "arn:aws:iam::${data.aws_caller_identity.current.id}:oidc-provider/${local.provider_arn}"
      namespace_service_accounts = ["${var.vpc_cni_namespace}:${var.vpc_cni_service_account_name}"]
    }
  }
}
resource "kubernetes_namespace" "vpc_cni" {
  count      = (var.vpc_cni_enabled && var.vpc_cni_namespace != "kube-system") ? 1 : 0

  metadata {
    name = var.vpc_cni_namespace
  }
}
resource "helm_release" "vpc_cni" {
  depends_on = [module.vpc_cni_ipv4_irsa_role, kubernetes_namespace.vpc_cni]
  count      = var.vpc_cni_enabled ? 1 : 0
  name       = var.vpc_cni_helm_chart_name
  chart      = var.vpc_cni_helm_chart_release_name
  repository = var.vpc_cni_helm_chart_repo
  version    = var.vpc_cni_helm_chart_version
  namespace  = var.vpc_cni_namespace

  set {
    name  = "crd.create"
    value = true
  }

  set {
    name  = "originalMatchLabels"
    value = true
  }

  set {
    name  = "serviceAccount.name"
    value = var.vpc_cni_service_account_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.vpc_cni_ipv4_irsa_role[0].iam_role_arn
  } 

  set {
    name  = "init.image.region"
    value = var.region
  }

  values = [
    yamlencode(var.vpc_cni_settings)
  ]
}