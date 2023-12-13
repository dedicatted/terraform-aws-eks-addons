module "cluster_autoscaler_irsa_role" {
  count  = var.cluster_autoscaler_enabled ? 1 : 0
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                        = var.cluster_autoscaler_irsa_role_name
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [var.cluster_name]

  oidc_providers = {
    ex = {
      provider_arn               = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
      namespace_service_accounts = ["kube-system:cluster-autoscaler"]
    }
  }
}


resource "helm_release" "cluster_autoscaler" {
  count      = var.cluster_autoscaler_enabled ? 1 : 0
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/autoscaler"
  name       = "cluster-autoscaler"
  chart      = "cluster-autoscaler"
  wait       = true
  version    = var.autoscaler_chart_version
  timeout    = "300"
  values = [
    <<-EOT
  {
    "cloudProvider"    : "aws",
    "awsRegion"        : "${var.region}",
    "autoDiscovery"     : {
      "clusterName"    : "${var.cluster_name}"
    },
    "fullnameOverride" : "cluster-autoscaler",
    "rbac" : {
      "create"        : true,
      "pspEnabled"    : false,
      "serviceAccount" : {
        "create"      : true,
        "name"        : "cluster-autoscaler",
        "annotations" : {
          "eks.amazonaws.com/role-arn" : "${module.cluster_autoscaler_irsa_role[0].iam_role_arn}"
        }
      }
    }
  }
  EOT
  ]
}