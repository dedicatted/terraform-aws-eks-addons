module "amazon_managed_service_prometheus_irsa_role" {
  count  = var.aws_prometheus_metrics_server_enabled ? 1 : 0
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                                       = "amp-iamproxy-ingest-role"
  attach_amazon_managed_service_prometheus_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = "arn:aws:iam::${data.aws_caller_identity.current.id}:oidc-provider/${local.provider_arn}"
      namespace_service_accounts = ["${var.aws_prometheus_metrics_server_namespace}:amp-iamproxy-ingest-service-account"]
    }
  }
}

resource "aws_prometheus_workspace" "aws_prometheus_workspace" {
  count = var.aws_prometheus_metrics_server_enabled ? 1 : 0
  alias = var.aws_prometheus_workspace_alias
}

resource "kubernetes_namespace" "awsprometheus_namespace" {
  count = (var.aws_prometheus_metrics_server_enabled && var.aws_prometheus_metrics_server_namespace != "kube-system") ? 1 : 0

  metadata {
    name = var.aws_prometheus_metrics_server_namespace
  }
}
resource "helm_release" "prometheus_install" {
  count      = var.aws_prometheus_metrics_server_enabled ? 1 : 0
  name       = var.aws_prometheus_metrics_server_release_name
  namespace  = var.aws_prometheus_metrics_server_namespace
  version    = var.aws_prometheus_metrics_server_chart_version
  repository = var.aws_prometheus_metrics_server_helm_chart_repo
  chart      = var.aws_prometheus_metrics_server_helm_chart_name
  set {
    name  = "serviceAccounts.server.name"
    value = "amp-iamproxy-ingest-service-account"
  }
  set {
    name  = "serviceAccounts.server.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.amazon_managed_service_prometheus_irsa_role[0].iam_role_arn
  }
  set {
    name  = "serviceAccounts.alertmanager.create"
    value = "false"
  }
  set {
    name  = "serviceAccounts.pushgateway.create"
    value = "false"
  }
  set {
    name  = "server.remoteWrite[0].url"
    value = "https://aps-workspaces.${var.region}.amazonaws.com/workspaces/${aws_prometheus_workspace.aws_prometheus_workspace[0].id}/api/v1/remote_write"
  }
  set {
    name  = "server.remoteWrite[0].sigv4.region"
    value = var.region
  }
  set {
    name  = "server.remoteWrite[0].queue_config.max_samples_per_send"
    value = 1000
  }
  set {
    name  = "server.remoteWrite[0].queue_config.max_shards"
    value = 200
  }
  set {
    name  = "server.remoteWrite[0].queue_config.capacity"
    value = 2500
  }
  set {
    name  = "alertmanager.create"
    value = "false"
  }
  set {
    name  = "pushgateway.create"
    value = "false"
  }
  values = [
    yamlencode(var.aws_prometheus_settings)
  ]
  depends_on = [aws_prometheus_workspace.aws_prometheus_workspace, module.amazon_managed_service_prometheus_irsa_role]
}