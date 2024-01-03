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
variable "provider_arn" {
  type        = string
  description = "providerarn"
  default     = ""
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
variable "external_dns_zone_type" {
  description = "Type of route53 zone (public | private)"
  type        = string
  default     = "public"
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
  default     = "1.6.2"
}

variable "alb_controller_irsa_role_name" {
  description = "Name of IRSA which created for application load balancer controller addons"
  type        = string
  default     = "AlbControllerIRSA"
}
variable "alb_ingress_type" {
  description = "Type of loadbalancer for creation"
  default     = "alb"
  type        = string
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
  default     = false
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

############################# EFS CSI Driver ############################

variable "efs_csi_enabled" {
  type        = bool
  default     = false
  description = "Variable indicating whether deployment is enabled."
}

variable "efs_csi_irsa_role_name" {
  description = "Name of IRSA which created for cert manager addons"
  type        = string
  default     = "EFSCSIDriverRSA"
}

variable "efs_csi_helm_chart_name" {
  type        = string
  default     = "aws-efs-csi-driver"
  description = "Amazon EFS CSI Driver chart name."
}

variable "efs_csi_helm_chart_release_name" {
  type        = string
  default     = "aws-efs-csi-driver"
  description = "Amazon EFS CSI Driver release name."
}

variable "efs_csi_helm_chart_repo" {
  type        = string
  default     = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  description = "Amazon EFS CSI Driver repository name."
}

variable "efs_csi_helm_chart_version" {
  type        = string
  default     = "2.2.7"
  description = "Amazon EFS CSI Driver chart version."
}

variable "efs_csi_namespace" {
  type        = string
  default     = "kube-system"
  description = "Kubernetes namespace to deploy EFS CSI Driver Helm chart."
}

variable "create_efs_storage_class" {
  type        = bool
  default     = false
  description = "Whether to create Storage class for EFS CSI driver."
}

variable "efs_csi_settings" {
  default     = {}
  type        = map(string)
  description = "Additional settings which will be passed to the Helm chart values, see https://github.com/kubernetes-sigs/aws-efs-csi-driver."
}

variable "efs_storage_class_name" {
  type        = string
  default     = "terraform-efs-storage-class"
  description = "Name of Storage Class custom resources"
}

####################################### METRICS SERVICE ######################################
variable "metrics_server_enabled" {
  type        = bool
  default     = false
  description = "Variable indicating whether deployment is enabled."
}
variable "metrics_server_helm_chart_repo" {
  type    = string
  default = "https://kubernetes-sigs.github.io/metrics-server/"
}
variable "metrics_server_helm_chart_name" {
  type    = string
  default = "metrics-server"
}
variable "metrics_server_helm_chart_version" {
  type    = string
  default = "3.11.0"

}
variable "metrics_server_namespace" {
  description = "Difine namespace for deploying metrics server"
  type        = string
  default     = "kube-system"
}

###################################### INGRESS NGINX #########################################
variable "ingress_nginx_enabled" {
  type        = bool
  default     = false
  description = "Variable indicating whether deployment is enabled."
}

variable "ingress_nginx_version" {
  description = "The metrics-server version to use. See https://kubernetes.github.io/ingress-nginx for available versions"
  type        = string
  default     = "4.7.3"
}

variable "ingress_nginx_namespace" {
  description = "Difine namespace for deploying metrics server"
  type        = string
  default     = "ingress-nginx"
}

variable "ingress_controller_type" {
  description = "Difine type of load balancer internal or external (internal | internet-facing)"
  default     = "internet-facing"
  type        = string
}
variable "ingress_nginx_settings" {
  type = map(any)
  default = {
  }
  description = "Additional setting for your ingress controller"
}

################################## NODE TERMINATION HANDLER ##########################

variable "node_termination_handler_enabled" {
  type        = bool
  default     = false
  description = "Variable indicating whether deployment is enabled."
}

variable "node_termination_handler_helm_chart_name" {
  type        = string
  default     = "aws-node-termination-handler"
  description = "Spot termination handler Helm chart name."
}

variable "node_termination_handler_helm_chart_release_name" {
  type        = string
  default     = "aws-node-termination-handler"
  description = "Spot termination handler Helm release name."
}

variable "node_termination_handler_helm_chart_repo" {
  type        = string
  default     = "https://aws.github.io/eks-charts"
  description = "Spot termination handler Helm repository name."
}

variable "node_termination_handler_helm_chart_version" {
  type        = string
  default     = "1.12.7"
  description = "Spot termination handler Helm chart version."
}

variable "node_termination_handler_namespace" {
  type        = string
  default     = "kube-system"
  description = "Kubernetes namespace to deploy Spot termination handler Helm chart."
}

variable "node_termination_handler_settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values."
}

######################################## KARPENTER ########################################

variable "karpenter_enabled" {
  type        = bool
  default     = false
  description = "Variable indicating whether deployment is enabled."
}
variable "karpenter_controller_irsa_role_name" {
  type        = string
  default     = "IrsaRoleKarpenter"
  description = "Name of IRSA which created for karpenter addons"
}
variable "karpenter_namespace" {
  type        = string
  default     = "karpenter"
  description = "Kubernetes namespace to deploy karpenter Helm chart."
}
variable "karpenter_helm_chart_repo" {
  type        = string
  default     = "https://charts.karpenter.sh"
  description = "Karpenter Helm repository name."
}
variable "karpenter_helm_chart_name" {
  type        = string
  default     = "karpenter"
  description = "Karpenter Helm chart name."
}
variable "karpenter_helm_chart_version" {
  type        = string
  default     = "v0.6.0"
  description = "Karpenter Helm chart version."
}

############################################# RANCHER ######################
variable "rancher_enabled" {
  type        = bool
  default     = false
  description = "Variable indicating whether deployment is enabled."
}
variable "rancher_repository" {
  type        = string
  default     = "https://releases.rancher.com/server-charts/latest"
  description = "Rancher Helm repository name."
}
variable "rancher_version" {
  type        = string
  default     = "2.8.0"
  description = "Rancher Helm chart version."
}
variable "rancher_domain" {
  type        = string
  description = "Domain for rancer to UI access"
}
variable "rancher_namespace" {
  type        = string
  default     = "kube-system"
  description = "Kubernetes namespace to deploy rancher Helm chart."
}
variable "rancher_chart_name" {
  type        = string
  default     = "rancher"
  description = "Rancher Helm chart name."
}

variable "rancher_bootstrapPassword" {
  type        = string
  default     = "admin"
  description = "Setup initial password while deploy rancher"
}

###################################### VPC CNI #############################

variable "vpc_cni_enabled" {
  type        = bool
  default     = false
  description = "Variable indicating whether deployment is enabled."
}
variable "vpc_cni_irsa_role_name" {
  type        = string
  default     = "VPCCVIIRSARole"
  description = "Name of IRSA which created for vpc cni"
}
variable "vpc_cni_helm_chart_name" {
  type        = string
  default     = "aws-vpc-cni"
  description = "VPC CNI Helm chart name."
}

variable "vpc_cni_helm_chart_release_name" {
  type        = string
  default     = "aws-vpc-cni"
  description = "VPC CNI Helm chart release name."
}

variable "vpc_cni_helm_chart_repo" {
  type        = string
  default     = "https://aws.github.io/eks-charts"
  description = "VPC CNI Helm repository name."
}

variable "vpc_cni_helm_chart_version" {
  type        = string
  default     = ""
  description = "VPC CNI Helm chart version."
}

variable "vpc_cni_namespace" {
  type        = string
  default     = "kube-system"
  description = "VPC CNI Helm chart namespace which the service will be created."
}

variable "vpc_cni_service_account_name" {
  type        = string
  default     = "aws-vpc-cni"
  description = "The kubernetes service account name for VPC CNI."
}

variable "vpc_cni_settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://github.com/aws/eks-charts/tree/master/stable/aws-vpc-cni."
}

################################## METRICS_SERVER_FOR_PROMETHEUS #################################
variable "aws_prometheus_metrics_server_enabled" {
  type        = bool
  default     = false
  description = "Variable indicating whether deployment is enabled."
}

variable "aws_prometheus_metrics_server_namespace" {
  type        = string
  default     = "monitoring"
  description = "VPC CNI Helm chart namespace which the service will be created."
}
variable "aws_prometheus_metrics_server_chart_version" {
  type        = string
  default     = "23.0.0"
  description = "Promtheus Helm chart version."
}
variable "aws_prometheus_metrics_server_helm_chart_repo" {
  type        = string
  default     = "https://prometheus-community.github.io/helm-charts"
  description = "Promtheus Helm repository name."
}
variable "aws_prometheus_metrics_server_helm_chart_name" {
  default     = "prometheus"
  type        = string
  description = "Prometheus Helm chart name."
}
variable "aws_prometheus_metrics_server_release_name" {
  default     = "prometheus"
  type        = string
  description = "Prometheus Helm chart release name."
}
variable "aws_prometheus_workspace_alias" {
  type        = string
  default     = "prometheus-terraform-workspace"
  description = "Name of amazon managed prometheus workspace."
}
variable "aws_prometheus_settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://github.com/aws/eks-charts/tree/master/stable/aws-vpc-cni."
}

############################## PROMETHEUS GRAFANA STACK ######################

variable "selfhosted_prometheus_grafana_enabled" {
  type        = bool
  default     = false
  description = "Variable indicating whether deployment is enabled."
}
variable "selfhosted_prometheus_grafana_namespace" {
  type        = string
  default     = "monitoring"
  description = "Prometheus Helm chart namespace which the service will be created."
}
variable "selfhosted_prometheus_release_name" {
  default     = "prometheus_grafana_stack"
  type        = string
  description = "Prometheus Helm chart release name."
}
variable "selfhosted_prometheus_chart_version" {
  type        = string
  default     = "55.5.0"
  description = "Promtheus Helm chart version."
}
variable "selfhosted_prometheus_helm_chart_name" {
  default     = "kube-prometheus-stack"
  type        = string
  description = "Prometheus Helm chart name."
}
variable "selfhosted_prometheus_helm_chart_repo" {
  type        = string
  default     = "https://prometheus-community.github.io/helm-charts"
  description = "Promtheus Helm repository name."
}
variable "selfhosted_prometheus_grafana_settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://prometheus-community.github.io/helm-charts"
}