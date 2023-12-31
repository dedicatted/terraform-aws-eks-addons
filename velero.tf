resource "random_pet" "valero_bucket_name" {
  count     = var.velero_enabled ? 1 : 0
  length    = 3
  separator = "-"
}
resource "aws_s3_bucket" "velero_bucket" {
  count  = var.velero_enabled ? 1 : 0
  bucket = var.velero_bucket_name != "" ? var.velero_bucket_name : random_pet.valero_bucket_name[0].id

  tags = {
    Terraform = "True"
  }
}

module "velero_irsa_role" {
  count  = var.velero_enabled ? 1 : 0
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = var.velero_irsa_role_name
  attach_velero_policy  = true
  velero_s3_bucket_arns = [resource.aws_s3_bucket.velero_bucket[0].arn]

  oidc_providers = {
    ex = {
      provider_arn               = "arn:aws:iam::${data.aws_caller_identity.current.id}:oidc-provider/${local.provider_arn}"
      namespace_service_accounts = ["velero:velero"]
    }
  }
}
resource "helm_release" "velero" {
  count            = var.velero_enabled ? 1 : 0
  depends_on       = [module.velero_irsa_role]
  name             = "velero"
  description      = "A Helm chart for velero"
  chart            = "velero"
  version          = var.velero_chart_version
  repository       = "https://vmware-tanzu.github.io/helm-charts/"
  namespace        = "velero"
  create_namespace = true

  values = [
    <<-EOT
  {
    "initContainers" : [
      {
        "name"            : "velero-plugin-for-aws",
        "image"           : "velero/velero-plugin-for-aws:v1.7.0",
        "imagePullPolicy" : "IfNotPresent",
        "volumeMounts"    : [
          {
            "mountPath" : "/target",
            "name"      : "plugins"
          }
        ]
      }
    ],
    "podAnnotations" : {
      "iam.amazonaws.com/role" : "${module.velero_irsa_role[0].iam_role_arn}"
    },
    "serviceAccount" : {
      "server" : {
        "create"       : true,
        "name"         : "velero",
        "annotations"  : {
          "eks.amazonaws.com/role-arn" : "${module.velero_irsa_role[0].iam_role_arn}"
        }
      }
    },
    "credentials" : {
      "useSecret" : false
    },
    "configuration" : {
      "backupStorageLocation" : [
        {
          "name"     : "${var.velero_bucket_name != "" ? var.velero_bucket_name : random_pet.valero_bucket_name[0].id}",
          "provider" : "aws",
          "bucket"   : "${var.velero_bucket_name != "" ? var.velero_bucket_name : random_pet.valero_bucket_name[0].id}",
          "default"  : true
        }
      ],
      "volumeSnapshotLocation" : [
        {
          "name"     : "${var.cluster_name}-volume-snapshot",
          "provider" : "aws"
        }
      ]
    }
  }
  EOT
  ]
}