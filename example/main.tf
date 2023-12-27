module "eks-addons" {
  source = "/home/user/proj/terraform-aws-eks-addons/."
  vpc_id = "vpc-0fcc0eb091c495d4f"
  region       = "us-east-1" # by default us-east-1
  cluster_name = "devops-eks"

  ## CLUSTER AUTOSCALER
  cluster_autoscaler_enabled = false # by default false

  ## EXTERNAL DNS
  external_dns_enabled = false # by default false

  ## ALB CONTROLLER
  aws_load_balancer_controller_enabled = false # by default false

  ## VELERO
  velero_enabled = false # by default false

  ## EBS CSI
  aws_ebs_csi_driver_enabled = false # by default false

  ## EXTERNAL SECRET
  external_secrets_enabled = false # by default false

  ## CERTIFICATION MANAGER
  cert_manager_enabled         = false
  cert_manager_hosted_zone_arn = ["arn:aws:route53:::hostedzone/ARN"]


  ## EFS CSI Driver
  efs_csi_enabled = false # by default false

  ## METRICS SERVICE
  metrics_server_enabled = false # by default false

  ## INGRESS NGINX
  ingress_nginx_enabled = false # by default false
  ## Karpenter
  karpenter_enabled = false # by default false

  ## Rancher
  rancher_enabled = false # by default false
  rancher_domain  = "example.com"
  # VPC CNI
  vpc_cni_enabled            = false    # by default false
  vpc_cni_helm_chart_version = "1.16.0" # by default take last available chart for your EKS cluster version
  # Metrics server for prometheus
  prometheus_metrics_server_enabled = false # by default false

}