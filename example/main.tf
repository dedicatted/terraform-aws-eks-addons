module "eks-addons" {
  source = "/home/user/proj/terraform-aws-eks-addons/."
  vpc_id = "vpc-0fcc0eb091c495d4f"
  region = "us-east-1" # by default us-east-1
  cluster_name = "devops-eks"

  ## CLUSTER AUTOSCALER
  cluster_autoscaler_enabled = true # by default false
  
  ## EXTERNAL DNS
  external_dns_enabled = true # by default false

  ## ALB CONTROLLER
  aws_load_balancer_controller_enabled = true # by default false
  
  ## VELERO
  velero_enabled = true # by default false

  ## EBS CSI
  aws_ebs_csi_driver_enabled = true # by default false

  ## EXTERNAL SECRET
  external_secrets_enabled = true # by default false

  ## CERTIFICATION MANAGER
  cert_manager_enabled = true
  cert_manager_hosted_zone_arn = ["arn:aws:route53:::hostedzone/ARN"]


  ## EFS CSI Driver
  efs_csi_enabled = true # by default false

  ## METRICS SERVICE
  metrics_server_enabled = true # by default false

  ## INGRESS NGINX
  ingress_nginx_enabled = true # by default false
  ## Karpenter
  karpenter_enabled = true # by default false

  ## Rancher
  rancher_enabled = true # by default false
  rancher_domain = "example.com"
  # VPC CNI
  vpc_cni_enabled = true # by default false
  # Metrics server for prometheus
  prometheus_metrics_server_enabled = true # by default false

}