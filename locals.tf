locals {
  provider_arn      = replace(data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer, "https://", "")
  extracted_version = var.vpc_cni_helm_chart_version != "" ? var.vpc_cni_helm_chart_version : join("", regex("v([0-9]+\\.[0-9]+\\.[0-9]+)", data.aws_eks_addon_version.vpc_cni_version[0].version))
}