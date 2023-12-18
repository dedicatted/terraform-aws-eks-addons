resource "kubernetes_namespace" "node_termination_handler_namespace" {
  count      = (var.karpenter_enabled && var.karpenter_namespace != "kube-system") ? 1 : 0

  metadata {
    name = var.node_termination_handler_namespace
  }
}
module "karpenter_controller_irsa_role" {
  count  = var.karpenter_enabled ? 1 : 0
  source = "../../modules/iam-role-for-service-accounts-eks"

  role_name                          = var.karpenter_controller_irsa_role_name
  attach_karpenter_controller_policy = true

  karpenter_controller_cluster_name       = var.cluster_name

  oidc_providers = {
    ex = {
      provider_arn               = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
      namespace_service_accounts = ["karpenter:karpenter"]
    }
  }

  tags = local.tags
}

resource "helm_release" "karpenter" {
  count  = var.karpenter_enabled ? 1 : 0
  namespace        = var.karpenter_namespace
  name       = "karpenter"
  repository = var.karpenter_helm_chart_repo
  chart      = var.karpenter_helm_chart_name
  version    = var.karpenter_helm_chart_version
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_assumable_role_karpenter.iam_role_arn
  }
  set {
    name  = "controller.clusterName"
    value = var.cluster_name
  }
  set {
    name  = "controller.clusterEndpoint"
    value = module.eks.cluster_endpoint
  }
  set {
    name  = "aws.defaultInstanceProfile"
    value = data.aws_eks_cluster.eks_cluster.role_arn
  }
  depends_on = [ module.karpenter_controller_irsa_role ]
}