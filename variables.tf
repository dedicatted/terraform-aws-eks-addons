################################## GLOBAL SETTING ###########################################
variable "vpc_id" {
  description = "ID of the VPC where the cluster was provisioned"
  type        = string
}
variable "region" {
  description = "Indicates where EKS cluster located (default value us-east-1)"
  type        = string
  default     = "us-east-1"
}
variable "cluster_name" {
  description = "AWS EKS cluster name with which terraform works"
  type        = string
}

################################### CLUSTER AUTOSCALER ######################################
variable "cluster_autoscaler_enabled" {
  description = "Enable cluster autoscaler add-ons"
  type        = bool
  default     = false
}

variable "autoscaler_chart_version" {
  description = "Cluster autoscaler chart version to use for the cluster autoscaler addons (i.e.: 9.29.1)"
  type        = string
  default     = "9.29.1"
}

variable "cluster_autoscaler_irsa_role_name" {
  description = "Name of IRSA which created for cluster autoscaler addons"
  type        = string
  default     = "ClusterAutoscalerIRSA"
}

################################### EXTERNAL DNS ######################################
variable "external_dns_enabled" {
  description = "Enable external dns add-ons"
  type        = bool
  default     = false
}

variable "external_dns_chart_version" {
  description = "External DNS chart version to use for the external DNS addons(i.e.: `6.20.4`)"
  type        = string
  default     = "6.20.4"
}

variable "route53_zone_name" {
  description = "Name of route 53 for external dns"
  type        = string
  nullable    = true
  default     = ""
}

variable "external_dns_irsa_role_name" {
  description = "Name of IRSA which created for external DNS addons"
  type        = string
  default     = "ExternalDNSIRSA"
}

################################### ALB CONTROLLER ######################################
variable "aws_load_balancer_controller_enabled" {
  description = "Enable load balancer controller add-ons"
  type        = bool
  default     = false
}

variable "alb_chart_version" {
  description = "ALB controller chart version to use for the ALB controller addons(i.e.: `1.5.4`)"
  type        = string
  default     = "1.5.4"
}

variable "alb_controller_irsa_role_name" {
  description = "Name of IRSA which created for application load balancer controller addons"
  type        = string
  default     = "AlbControllerIRSA"
}

##################################### VELERO ############################################
variable "velero_enabled" {
  description = "Enable velero add-ons"
  type        = bool
  default     = false
}

variable "velero_chart_version" {
  description = "Velero chart version to use for the velero addons(i.e.: `4.1.3`)"
  type        = string
  default     = "4.1.3"
}

variable "velero_bucket_name" {
  description = "Name of bucket created for velero addons"
  type        = string
  default     = "valero-test-bucket-id1234023123"
}

variable "velero_irsa_role_name" {
  description = "Name of IRSA which created for velero addons"
  type        = string
  default     = "VeleroIRSA"
}

##################################### EBS CSI ###########################################
variable "aws_ebs_csi_driver_enabled" {
  description = "Enable ebs csi add-ons"
  type        = bool
  default     = false
}

variable "ebs_csi_kms_key_arn" {
  description = "KMS key arn which will be use for encrypt EBS volume y eks ebs csi addons"
  type        = string
  default     = ""
}

variable "ebs_chart_version" {
  description = "EBS chart version to use for the ebs addons(i.e.: `2.20.0`)"
  type        = string
  default     = "2.20.0"
}

variable "ebs_csi_reclaimepolicy" {
  description = "The reclaim policy for a PersistentVolume tells the cluster what to do with the volume after it has been released of its claim. Got 3 option: Retained, Recycled, or Deleted"
  type        = string
  default     = "Delete"
}

variable "ebs_csi_irsa_role_name" {
  description = "Name of IRSA which created for ebs csi addons"
  type        = string
  default     = "EbsCsiIRSA"
}

##################################### EXTERNAL SECRET ###################################
variable "external_secrets_enabled" {
  description = "Enable external secret add-ons"
  type        = bool
  default     = false
}

variable "external_secrets_chart_version" {
  description = "External secrets chart version to use for the external secrets addons(i.e.: `0.9.0`)"
  default     = "0.9.9"
}

variable "external_secrets_irsa_role_name" {
  description = "Name of IRSA which created for external secret addons"
  type        = string
  default     = "ExternalSecretIRSA"
}

variable "external_secrets_kms_key_arn" {
  description = "KMS key arn which use Parameter Store or Secret manager"
  type        = list(string)
  default     = [""]
}

variable "extrenal_secret_store" {
  description = "Defined which secret manager used in ClusterSecretStore (ParametesStore or SecretStore)"
  type        = string
  default     = "SecretStore"
}

variable "cluster_secret_store_name" {
  description = "Define name of cluster secret store custom resource"
  type        = string
  default     = "TerraformClusterSecretStore"
}

######################### CERTIFICATION MANAGER ##############################
variable "cert_manager_enabled" {
  type        = bool
  default     = true
  description = "Variable indicating whether deployment is enabled."
}

variable "cert_manager_helm_chart_name" {
  type        = string
  default     = "cert-manager"
  description = "Cert Manager Helm chart name to be installed"
}

variable "cert_manager_helm_chart_release_name" {
  type        = string
  default     = "cert-manager"
  description = "Helm release name"
}

variable "cert_manager_helm_chart_version" {
  type        = string
  default     = "1.1.0"
  description = "Cert Manager Helm chart version."
}

variable "cert_manager_helm_chart_repo" {
  type        = string
  default     = "https://charts.jetstack.io"
  description = "Cert Manager repository name."
}

variable "cert_manager_install_CRDs" {
  type        = bool
  default     = true
  description = "To automatically install and manage the CRDs as part of your Helm release."
}

variable "cert_manager_create_namespace" {
  type        = bool
  default     = true
  description = "Whether to create Kubernetes namespace with name defined by `namespace`."
}

variable "cert_manager_settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values."
}

variable "cert_manager_irsa_role_name" {
  description = "Name of IRSA which created for cert manager addons"
  type        = string
  default     = "CertManagerIRSA"
}

variable "cert_manager_hosted_zone_arn" {
  description = "List of hosted zone arns which would be managed by cert manager"
  type        = list(string)
  default     = [""]
}