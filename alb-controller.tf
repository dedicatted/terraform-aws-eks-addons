################################################################################
# ALB-Ingress Configuration
################################################################################
module "load_balancer_controller_irsa_role" {
  count  = var.aws_load_balancer_controller_enabled ? 1 : 0
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = var.alb_controller_irsa_role_name
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = "arn:aws:iam::${data.aws_caller_identity.current.id}:oidc-provider/${local.provider_arn}"
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "helm_release" "alb_ingress" {
  count      = var.aws_load_balancer_controller_enabled ? 1 : 0
  depends_on = [module.load_balancer_controller_irsa_role]
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  name       = "aws-load-balancer-controller"
  chart      = "aws-load-balancer-controller"
  wait       = true
  timeout    = "300"
  version    = var.alb_chart_version

  values = [
    <<-EOT
  {
    "clusterName"    : "${var.cluster_name}",
    "region"         : "${var.region}",
    "serviceAccount" : {
      "create"       : true,
      "name"         : "aws-load-balancer-controller",
      "annotations"  : {
        "eks.amazonaws.com/role-arn" : "${module.load_balancer_controller_irsa_role[0].iam_role_arn}"
      }
    },
    "vpcId"          : "${var.vpc_id}",
    "ingressClass"   : "${var.alb_ingress_type}"
  }
  EOT
  ]
}

resource "time_sleep" "wait_for_load_balancer_and_route53_record" {
  count            = var.aws_load_balancer_controller_enabled ? 1 : 0
  depends_on       = [helm_release.alb_ingress]
  destroy_duration = "300s"
}