module "efs_csi_irsa_role" {
  count      = var.efs_csi_enabled ? 1 : 0
  source = "../../modules/iam-role-for-service-accounts-eks"

  role_name             = var.efs_csi_irsa_role_name
  attach_efs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = data.aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
      namespace_service_accounts = ["kube-system:efs-csi-controller-sa", "kube-system:efs-csi-node-sa"]
    }
  }
}

resource "helm_release" "kubernetes_efs_csi_driver" {
  count      = var.efs_csi_enabled ? 1 : 0
  name       = var.efs_csi_helm_chart_name
  chart      = var.efs_csi_helm_chart_release_name
  repository = var.efs_csi_helm_chart_repo
  version    = var.efs_csi_helm_chart_version
  namespace  = var.efs_csi_namespace

  set {
    name  = "controller.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.external_secrets_irsa_role[0].iam_role_arn
  }

  set {
    name = "node.serviceAccount.create"
    # We're using the same service account for both the nodes and controllers,
    # and we're already creating the service account in the controller config
    # above.
    value = "true"
  }

  set {
    name  = "node.serviceAccount.name"
    value = "efs-csi-node-sa"
  }

  set {
    name  = "node.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.external_secrets_irsa_role[0].iam_role_arn
  }

  values = [
    yamlencode(var.efs_csi_settings)
  ]
}


resource "kubectl_manifest" "storage_class" {
  count      = (var.efs_csi_enabled && var.create_efs_storage_class) ? 1 : 0
  yaml_body  = <<YAML
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: ${var.efs_storage_class_name}
provisioner: efs.csi.aws.com
YAML
  depends_on = [helm_release.kubernetes_efs_csi_driver]
}