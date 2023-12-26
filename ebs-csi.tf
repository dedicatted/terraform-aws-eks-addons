module "kms_key_csi" {
  count  = var.aws_ebs_csi_driver_enabled && var.ebs_csi_kms_key_arn == "" ? 1 : 0
  source = "github.com/dedicatted/devops-tech//terraform/aws/modules/terraform-aws-kms"
  deletion_window_in_days = 7
  key_administrators = [
    data.aws_caller_identity.current.arn
  ]
  key_users = [
    module.ebs_csi_irsa_role[0].iam_role_arn
  ]
}

module "ebs_csi_irsa_role" {
  count  = var.aws_ebs_csi_driver_enabled ? 1 : 0
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = var.ebs_csi_irsa_role_name
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}


resource "helm_release" "ebs_csi_driver" {
  count      = var.aws_ebs_csi_driver_enabled ? 1 : 0
  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  version    = var.ebs_chart_version
  namespace  = "kube-system"

  values = [
    <<-EOT
    "storageClasses" : {
      {
        "name"                : "ebs-sc",
        "annotations"         : {
          "storageclass.kubernetes.io/is-default-class" : "true"
        },
        "volumeBindingMode"   : "WaitForFirstConsumer",
        "reclaimPolicy"       : "${var.ebs_csi_reclaimepolicy}",
        "parameters"          : {
          "type"      : "gp3",
          "encrypted" : "true",
          "kmsKeyId"  : "${var.ebs_csi_kms_key_arn != "" ? var.ebs_csi_kms_key_arn : module.kms_key_csi[0].key_arn}"
        }
      }
    },
    "controller" : {
      "replicaCount" : 2,
      "serviceAccount" : {
        "create"       : true,
        "name"         : "ebs-csi-controller-sa",
        "annotations"  : {
          "eks.amazonaws.com/role-arn"              : "${module.ebs_csi_irsa_role[0].iam_role_arn}",
          "meta.helm.sh/release-name"               : "aws-ebs-csi-driver",
          "meta.helm.sh/release-namespace"          : "kube-system"
        }
      }
    }
  EOT
  ]
}