module "external_secrets_irsa_role" {
  count  = var.external_secrets_enabled ? 1 : 0
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                                          = var.external_secrets_irsa_role_name
  attach_external_secrets_policy                     = true
  external_secrets_kms_key_arns                      = var.external_secrets_kms_key_arn
  external_secrets_secrets_manager_create_permission = false

  oidc_providers = {
    ex = {
      provider_arn               = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
      namespace_service_accounts = ["external-secrets:external-secrets"]
    }
  }
}

resource "helm_release" "external_secrets" {
  count            = var.external_secrets_enabled ? 1 : 0
  depends_on       = [module.external_secrets_irsa_role]
  repository       = "https://charts.external-secrets.io"
  name             = "external-secrets"
  chart            = "external-secrets"
  version          = var.external_secrets_chart_version
  wait             = true
  timeout          = "300"
  create_namespace = true
  namespace        = "external-secrets"
  set {
    name  = "serviceAccount.create"
    value = true
  }
  set {
    name  = "serviceAccount.name"
    value = "external-secrets"
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.external_secrets_irsa_role[0].iam_role_arn
  }
}
# Wait until external secrets addon finalizing
resource "time_sleep" "wait_for_external_secrets" {
  count      = var.external_secrets_enabled ? 1 : 0
  depends_on = [helm_release.external_secrets]

  create_duration = "120s"
}
resource "kubectl_manifest" "external_secrets_cluster_store" {
  yaml_body  = <<YAML
apiVersion: "external-secrets.io/v1beta1"
kind: "ClusterSecretStore"
metadata:
  name: ${var.cluster_secret_store_name}
spec:
  provider:
    aws:
      service: ${var.extrenal_secret_store}
      region: ${var.region}
      auth:
        jwt:
          serviceAccountRef:
            name: "external-secrets"
            namespace: "external-secrets"
  YAML
  depends_on = [time_sleep.wait_for_external_secrets]
}