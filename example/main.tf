module "eks-addons" {
  source = "github.com/dedicatted/terraform-aws-eks-addons"
  vpc_id = "vpc-123456123412"
  region = "eu-central-1" # by default us-east-1
  oidc_provider_arn = "PASS_OIDC_PROVIDER_ARN_HERE"
  cluster_name = "test-cluster"
  eks_cluster_certificate = "PASS_CA_HERE"
  eks_cluster_endpoint = "PASS_EKS_CLUSTER_ENDPOINT_HERE"

  ## CLUSTER AUTOSCALER
  cluster_autoscaler_enabled = true # by default false
  
  ## EXTERNAL DNS
  external_dns_enabled = true # by default false
  route53_zone_name = "PASS YOU ROUTE53 ZONE NAME"

  ## ALB CONTROLLER
  aws_load_balancer_controller_enabled = true # by default false
  
  ## VELERO
  velero_enabled = true # by default false

  ## EBS CSI
  aws_ebs_csi_driver_enabled = true # by default false

  ## EXTERNAL SECRET
  external_secrets_enabled = true
  external_secrets_kms_key_arn = ["kms_key_arn_for_encrypt_SecretStore"]

  ## CERTIFICATION MANAGER
  cert_manager_enabled = true
  cert_manager_hosted_zone_arn = ["hosted_zone_arn_which_cert_mager_managed"]
}