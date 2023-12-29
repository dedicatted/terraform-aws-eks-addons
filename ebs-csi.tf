module "kms_key_csi" {
  count  = var.aws_ebs_csi_driver_enabled && var.ebs_csi_kms_key_arn == "" ? 1 : 0
  source = "github.com/dedicatted/devops-tech//terraform/aws/modules/terraform-aws-kms"
  deletion_window_in_days = 7
  key_administrators = [
    data.aws_caller_identity.current.arn,
    module.ebs_csi_irsa_role[0].iam_role_arn,
  ]
  key_users = [
    module.ebs_csi_irsa_role[0].iam_role_arn,
  ]
  depends_on = [module.ebs_csi_irsa_role, module.amazon_managed_service_prometheus_irsa_role]
}

module "ebs_csi_irsa_role" {
  count  = var.aws_ebs_csi_driver_enabled ? 1 : 0
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = var.ebs_csi_irsa_role_name
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = "arn:aws:iam::${data.aws_caller_identity.current.id}:oidc-provider/${local.provider_arn}"
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}
data "aws_iam_policy_document" "aws_ebs_csi_driver_kms" {
  count = var.aws_ebs_csi_driver_enabled && var.ebs_csi_kms_key_arn == "" ? 1 : 0
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["${module.kms_key_csi[0].key_arn}"]
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]

  }
}

resource "aws_iam_policy" "aws_ebs_csi_driver_kms" {
  count       = var.aws_ebs_csi_driver_enabled && var.ebs_csi_kms_key_arn == "" ? 1 : 0
  name        = "KMS_Key_For_Encryption_On_EBS_Policy"
  description = "IAM Policy for KMS permission for AWS EBS CSI Driver"
  policy      = data.aws_iam_policy_document.aws_ebs_csi_driver_kms[0].json
}
resource "aws_iam_role_policy_attachment" "attach_kms_policy" {
  count      = var.aws_ebs_csi_driver_enabled && var.ebs_csi_kms_key_arn == "" ? 1 : 0
  depends_on = [module.ebs_csi_irsa_role]
  role       = var.ebs_csi_irsa_role_name
  policy_arn = aws_iam_policy.aws_ebs_csi_driver_kms[0].arn
}

resource "helm_release" "ebs_csi_driver" {
  depends_on = [module.ebs_csi_irsa_role]
  count      = var.aws_ebs_csi_driver_enabled ? 1 : 0
  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  version    = var.ebs_chart_version
  namespace  = "kube-system"
  values = [<<EOF
storageClasses:
# Add StorageClass resources like:
- name: ebs-sc
  # annotation metadata
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
  # defaults to WaitForFirstConsumer
  volumeBindingMode: WaitForFirstConsumer
  # defaults to Delete
  reclaimPolicy: ${var.ebs_csi_reclaimepolicy}
  parameters:
    type: gp3
    encrypted: "true"
    kmsKeyId: "${var.ebs_csi_kms_key_arn != "" ? var.ebs_csi_kms_key_arn : module.kms_key_csi[0].key_arn}"


controller:
  replicaCount: 2
  serviceAccount:
    create: true
    name: ebs-csi-controller-sa
    annotations:
      eks.amazonaws.com/role-arn: ${module.ebs_csi_irsa_role[0].iam_role_arn}
      meta.helm.sh/release-name: aws-ebs-csi-driver
      meta.helm.sh/release-namespace: kube-system
EOF
  ]
}