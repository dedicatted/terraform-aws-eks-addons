# Terraform Module: terraform-aws-eks-addons
# This module facilitates deployment of AWS EKS Addons via terraform in existing EKS cluster.

## Overview
The 'terraform-aws-eks-addons' module streamlines the deployment of essential add-ons and configurations for Amazon EKS (Elastic Kubernetes Service) infrastructure using Terraform. This module is designed to facilitate the incorporation of key components that enhance the functionality and management of your EKS cluster. This module contains list of addons : Velere, External Secret, External DNS, EBS CSI Driver, EFS CSI Driver Cluster Autoscaler, Cert Manager, Load Balancer Controller, metrics server, nginx ingress controller, karpenter, rancher, vpc cni, aws prometheus managed service.
## Usage
```hcl
//Configuration to call the module
module "eks-addons" {
  source       = "github.com/dedicatted/terraform-aws-eks-addons"
  vpc_id       = "vpc-example123"
  region       = "us-east-1" # by default us-east-1
  cluster_name = "example-eks"
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

  prometheus_grafana_enabled = true # by default false
  prometheus_grafana_settings = {
    grafana = {
      ingress = {
        enabled          = true
        ingressClassName = "nginx"
        hosts            = ["grafana.domain.com"]
      }
    }
    # You can add more settings for Prometheus or other components if needed

}
```
### Note
* For use rancher you should enabled cert managre and ingress controller
* For use prometheus you should enabled ebs csi driver
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.47 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.6 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.0.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.47 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.6 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 1.7.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | >= 0.9 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_amazon_managed_service_prometheus_irsa_role"></a> [amazon\_managed\_service\_prometheus\_irsa\_role](#module\_amazon\_managed\_service\_prometheus\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_cert_manager_irsa_role"></a> [cert\_manager\_irsa\_role](#module\_cert\_manager\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_cluster_autoscaler_irsa_role"></a> [cluster\_autoscaler\_irsa\_role](#module\_cluster\_autoscaler\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_ebs_csi_irsa_role"></a> [ebs\_csi\_irsa\_role](#module\_ebs\_csi\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_efs_csi_irsa_role"></a> [efs\_csi\_irsa\_role](#module\_efs\_csi\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_external_dns_irsa_role"></a> [external\_dns\_irsa\_role](#module\_external\_dns\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_external_secrets_irsa_role"></a> [external\_secrets\_irsa\_role](#module\_external\_secrets\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_karpenter_controller_irsa_role"></a> [karpenter\_controller\_irsa\_role](#module\_karpenter\_controller\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_kms_key_csi"></a> [kms\_key\_csi](#module\_kms\_key\_csi) | github.com/dedicatted/devops-tech//terraform/aws/modules/terraform-aws-kms | n/a |
| <a name="module_load_balancer_controller_irsa_role"></a> [load\_balancer\_controller\_irsa\_role](#module\_load\_balancer\_controller\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_velero_irsa_role"></a> [velero\_irsa\_role](#module\_velero\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_vpc_cni_ipv4_irsa_role"></a> [vpc\_cni\_ipv4\_irsa\_role](#module\_vpc\_cni\_ipv4\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.aws_ebs_csi_driver_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.attach_kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_prometheus_workspace.prometheus_workspace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/prometheus_workspace) | resource |
| [aws_s3_bucket.velero_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [helm_release.alb_ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external_secrets](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.karpenter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kubernetes_efs_csi_driver](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.metrics_server](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.node_termination_handler](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus_grafana_install](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus_install](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.rancher](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.velero](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.vpc_cni](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.external_secrets_cluster_store](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubectl_manifest.storage_class](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.ingress_nginx_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.karpenter_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.metrics_server_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.node_termination_handler_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.prometheus_grafana_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.prometheus_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.rancher_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.vpc_cni](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [random_pet.valero_bucket_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [time_sleep.wait_for_load_balancer_and_route53_record](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_addon_version.vpc_cni_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_addon_version) | data source |
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_iam_policy_document.aws_ebs_csi_driver_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.external_dns_zone_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_chart_version"></a> [alb\_chart\_version](#input\_alb\_chart\_version) | ALB controller chart version to use for the ALB controller addons(i.e.: `1.5.4`) | `string` | `"1.6.2"` | no |
| <a name="input_alb_controller_irsa_role_name"></a> [alb\_controller\_irsa\_role\_name](#input\_alb\_controller\_irsa\_role\_name) | Name of IRSA which created for application load balancer controller addons | `string` | `"AlbControllerIRSA"` | no |
| <a name="input_alb_ingress_type"></a> [alb\_ingress\_type](#input\_alb\_ingress\_type) | Type of loadbalancer for creation | `string` | `"alb"` | no |
| <a name="input_autoscaler_chart_version"></a> [autoscaler\_chart\_version](#input\_autoscaler\_chart\_version) | Cluster autoscaler chart version to use for the cluster autoscaler addons (i.e.: 9.29.1) | `string` | `"9.29.1"` | no |
| <a name="input_aws_ebs_csi_driver_enabled"></a> [aws\_ebs\_csi\_driver\_enabled](#input\_aws\_ebs\_csi\_driver\_enabled) | Enable ebs csi add-ons | `bool` | `false` | no |
| <a name="input_aws_load_balancer_controller_enabled"></a> [aws\_load\_balancer\_controller\_enabled](#input\_aws\_load\_balancer\_controller\_enabled) | Enable load balancer controller add-ons | `bool` | `false` | no |
| <a name="input_cert_manager_enabled"></a> [cert\_manager\_enabled](#input\_cert\_manager\_enabled) | Variable indicating whether deployment is enabled. | `bool` | `false` | no |
| <a name="input_cert_manager_hosted_zone_arn"></a> [cert\_manager\_hosted\_zone\_arn](#input\_cert\_manager\_hosted\_zone\_arn) | List of hosted zone arns which would be managed by cert manager | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_cert_manager_irsa_role_name"></a> [cert\_manager\_irsa\_role\_name](#input\_cert\_manager\_irsa\_role\_name) | Name of IRSA which created for cert manager addons | `string` | `"CertManagerIRSA"` | no |
| <a name="input_cluster_autoscaler_enabled"></a> [cluster\_autoscaler\_enabled](#input\_cluster\_autoscaler\_enabled) | Enable cluster autoscaler add-ons | `bool` | `false` | no |
| <a name="input_cluster_autoscaler_irsa_role_name"></a> [cluster\_autoscaler\_irsa\_role\_name](#input\_cluster\_autoscaler\_irsa\_role\_name) | Name of IRSA which created for cluster autoscaler addons | `string` | `"ClusterAutoscalerIRSA"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | AWS EKS cluster name with which terraform works | `string` | n/a | yes |
| <a name="input_cluster_secret_store_name"></a> [cluster\_secret\_store\_name](#input\_cluster\_secret\_store\_name) | Define name of cluster secret store custom resource | `string` | `"TerraformClusterSecretStore"` | no |
| <a name="input_create_efs_storage_class"></a> [create\_efs\_storage\_class](#input\_create\_efs\_storage\_class) | Whether to create Storage class for EFS CSI driver. | `bool` | `false` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Whether to create Kubernetes namespace with name defined by `namespace`. | `bool` | `true` | no |
| <a name="input_ebs_chart_version"></a> [ebs\_chart\_version](#input\_ebs\_chart\_version) | EBS chart version to use for the ebs addons(i.e.: `2.20.0`) | `string` | `"2.20.0"` | no |
| <a name="input_ebs_csi_irsa_role_name"></a> [ebs\_csi\_irsa\_role\_name](#input\_ebs\_csi\_irsa\_role\_name) | Name of IRSA which created for ebs csi addons | `string` | `"EbsCsiIRSA"` | no |
| <a name="input_ebs_csi_kms_key_arn"></a> [ebs\_csi\_kms\_key\_arn](#input\_ebs\_csi\_kms\_key\_arn) | KMS key arn which will be use for encrypt EBS volume y eks ebs csi addons | `string` | `""` | no |
| <a name="input_ebs_csi_reclaimepolicy"></a> [ebs\_csi\_reclaimepolicy](#input\_ebs\_csi\_reclaimepolicy) | The reclaim policy for a PersistentVolume tells the cluster what to do with the volume after it has been released of its claim. Got 3 option: Retained, Recycled, or Deleted | `string` | `"Delete"` | no |
| <a name="input_efs_csi_enabled"></a> [efs\_csi\_enabled](#input\_efs\_csi\_enabled) | Variable indicating whether deployment is enabled. | `bool` | `false` | no |
| <a name="input_efs_csi_helm_chart_name"></a> [efs\_csi\_helm\_chart\_name](#input\_efs\_csi\_helm\_chart\_name) | Amazon EFS CSI Driver chart name. | `string` | `"aws-efs-csi-driver"` | no |
| <a name="input_efs_csi_helm_chart_release_name"></a> [efs\_csi\_helm\_chart\_release\_name](#input\_efs\_csi\_helm\_chart\_release\_name) | Amazon EFS CSI Driver release name. | `string` | `"aws-efs-csi-driver"` | no |
| <a name="input_efs_csi_helm_chart_repo"></a> [efs\_csi\_helm\_chart\_repo](#input\_efs\_csi\_helm\_chart\_repo) | Amazon EFS CSI Driver repository name. | `string` | `"https://kubernetes-sigs.github.io/aws-efs-csi-driver/"` | no |
| <a name="input_efs_csi_helm_chart_version"></a> [efs\_csi\_helm\_chart\_version](#input\_efs\_csi\_helm\_chart\_version) | Amazon EFS CSI Driver chart version. | `string` | `"2.2.7"` | no |
| <a name="input_efs_csi_irsa_role_name"></a> [efs\_csi\_irsa\_role\_name](#input\_efs\_csi\_irsa\_role\_name) | Name of IRSA which created for cert manager addons | `string` | `"EFSCSIDriverRSA"` | no |
| <a name="input_efs_csi_namespace"></a> [efs\_csi\_namespace](#input\_efs\_csi\_namespace) | Kubernetes namespace to deploy EFS CSI Driver Helm chart. | `string` | `"kube-system"` | no |
| <a name="input_efs_csi_settings"></a> [efs\_csi\_settings](#input\_efs\_csi\_settings) | Additional settings which will be passed to the Helm chart values, see https://github.com/kubernetes-sigs/aws-efs-csi-driver. | `map(string)` | `{}` | no |
| <a name="input_efs_storage_class_name"></a> [efs\_storage\_class\_name](#input\_efs\_storage\_class\_name) | Name of Storage Class custom resources | `string` | `"terraform-efs-storage-class"` | no |
| <a name="input_external_dns_chart_version"></a> [external\_dns\_chart\_version](#input\_external\_dns\_chart\_version) | External DNS chart version to use for the external DNS addons(i.e.: `6.20.4`) | `string` | `"6.20.4"` | no |
| <a name="input_external_dns_enabled"></a> [external\_dns\_enabled](#input\_external\_dns\_enabled) | Enable external dns add-ons | `bool` | `false` | no |
| <a name="input_external_dns_irsa_role_name"></a> [external\_dns\_irsa\_role\_name](#input\_external\_dns\_irsa\_role\_name) | Name of IRSA which created for external DNS addons | `string` | `"ExternalDNSIRSA"` | no |
| <a name="input_external_dns_zone_type"></a> [external\_dns\_zone\_type](#input\_external\_dns\_zone\_type) | Type of route53 zone (public \| private) | `string` | `"public"` | no |
| <a name="input_external_secrets_chart_version"></a> [external\_secrets\_chart\_version](#input\_external\_secrets\_chart\_version) | External secrets chart version to use for the external secrets addons(i.e.: `0.9.0`) | `string` | `"0.9.9"` | no |
| <a name="input_external_secrets_enabled"></a> [external\_secrets\_enabled](#input\_external\_secrets\_enabled) | Enable external secret add-ons | `bool` | `false` | no |
| <a name="input_external_secrets_irsa_role_name"></a> [external\_secrets\_irsa\_role\_name](#input\_external\_secrets\_irsa\_role\_name) | Name of IRSA which created for external secret addons | `string` | `"ExternalSecretIRSA"` | no |
| <a name="input_external_secrets_kms_key_arn"></a> [external\_secrets\_kms\_key\_arn](#input\_external\_secrets\_kms\_key\_arn) | KMS key arn which use Parameter Store or Secret manager | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_extrenal_secret_store"></a> [extrenal\_secret\_store](#input\_extrenal\_secret\_store) | Defined which secret manager used in ClusterSecretStore (ParametesStore or SecretStore) | `string` | `"SecretStore"` | no |
| <a name="input_helm_chart_name"></a> [helm\_chart\_name](#input\_helm\_chart\_name) | Cert Manager Helm chart name to be installed | `string` | `"cert-manager"` | no |
| <a name="input_helm_chart_release_name"></a> [helm\_chart\_release\_name](#input\_helm\_chart\_release\_name) | Helm release name | `string` | `"cert-manager"` | no |
| <a name="input_helm_chart_repo"></a> [helm\_chart\_repo](#input\_helm\_chart\_repo) | Cert Manager repository name. | `string` | `"https://charts.jetstack.io"` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Cert Manager Helm chart version. | `string` | `"1.1.0"` | no |
| <a name="input_ingress_controller_type"></a> [ingress\_controller\_type](#input\_ingress\_controller\_type) | Difine type of load balancer internal or external (internal \| internet-facing) | `string` | `"internet-facing"` | no |
| <a name="input_ingress_nginx_enabled"></a> [ingress\_nginx\_enabled](#input\_ingress\_nginx\_enabled) | Variable indicating whether deployment is enabled. | `bool` | `false` | no |
| <a name="input_ingress_nginx_namespace"></a> [ingress\_nginx\_namespace](#input\_ingress\_nginx\_namespace) | Difine namespace for deploying metrics server | `string` | `"ingress-nginx"` | no |
| <a name="input_ingress_nginx_settings"></a> [ingress\_nginx\_settings](#input\_ingress\_nginx\_settings) | Additional setting for your ingress controller | `map(any)` | `{}` | no |
| <a name="input_ingress_nginx_version"></a> [ingress\_nginx\_version](#input\_ingress\_nginx\_version) | The metrics-server version to use. See https://kubernetes.github.io/ingress-nginx for available versions | `string` | `"4.7.3"` | no |
| <a name="input_install_CRDs"></a> [install\_CRDs](#input\_install\_CRDs) | To automatically install and manage the CRDs as part of your Helm release. | `bool` | `true` | no |
| <a name="input_karpenter_controller_irsa_role_name"></a> [karpenter\_controller\_irsa\_role\_name](#input\_karpenter\_controller\_irsa\_role\_name) | Name of IRSA which created for karpenter addons | `string` | `"IrsaRoleKarpenter"` | no |
| <a name="input_karpenter_enabled"></a> [karpenter\_enabled](#input\_karpenter\_enabled) | Variable indicating whether deployment is enabled. | `bool` | `false` | no |
| <a name="input_karpenter_helm_chart_name"></a> [karpenter\_helm\_chart\_name](#input\_karpenter\_helm\_chart\_name) | Karpenter Helm chart name. | `string` | `"karpenter"` | no |
| <a name="input_karpenter_helm_chart_repo"></a> [karpenter\_helm\_chart\_repo](#input\_karpenter\_helm\_chart\_repo) | Karpenter Helm repository name. | `string` | `"https://charts.karpenter.sh"` | no |
| <a name="input_karpenter_helm_chart_version"></a> [karpenter\_helm\_chart\_version](#input\_karpenter\_helm\_chart\_version) | Karpenter Helm chart version. | `string` | `"v0.6.0"` | no |
| <a name="input_karpenter_namespace"></a> [karpenter\_namespace](#input\_karpenter\_namespace) | Kubernetes namespace to deploy karpenter Helm chart. | `string` | `"karpenter"` | no |
| <a name="input_metrics_server_enabled"></a> [metrics\_server\_enabled](#input\_metrics\_server\_enabled) | Variable indicating whether deployment is enabled. | `bool` | `false` | no |
| <a name="input_metrics_server_helm_chart_name"></a> [metrics\_server\_helm\_chart\_name](#input\_metrics\_server\_helm\_chart\_name) | n/a | `string` | `"metrics-server"` | no |
| <a name="input_metrics_server_helm_chart_repo"></a> [metrics\_server\_helm\_chart\_repo](#input\_metrics\_server\_helm\_chart\_repo) | n/a | `string` | `"https://kubernetes-sigs.github.io/metrics-server/"` | no |
| <a name="input_metrics_server_helm_chart_version"></a> [metrics\_server\_helm\_chart\_version](#input\_metrics\_server\_helm\_chart\_version) | n/a | `string` | `"3.11.0"` | no |
| <a name="input_metrics_server_namespace"></a> [metrics\_server\_namespace](#input\_metrics\_server\_namespace) | Difine namespace for deploying metrics server | `string` | `"kube-system"` | no |
| <a name="input_node_termination_handler_enabled"></a> [node\_termination\_handler\_enabled](#input\_node\_termination\_handler\_enabled) | Variable indicating whether deployment is enabled. | `bool` | `false` | no |
| <a name="input_node_termination_handler_helm_chart_name"></a> [node\_termination\_handler\_helm\_chart\_name](#input\_node\_termination\_handler\_helm\_chart\_name) | Spot termination handler Helm chart name. | `string` | `"aws-node-termination-handler"` | no |
| <a name="input_node_termination_handler_helm_chart_release_name"></a> [node\_termination\_handler\_helm\_chart\_release\_name](#input\_node\_termination\_handler\_helm\_chart\_release\_name) | Spot termination handler Helm release name. | `string` | `"aws-node-termination-handler"` | no |
| <a name="input_node_termination_handler_helm_chart_repo"></a> [node\_termination\_handler\_helm\_chart\_repo](#input\_node\_termination\_handler\_helm\_chart\_repo) | Spot termination handler Helm repository name. | `string` | `"https://aws.github.io/eks-charts"` | no |
| <a name="input_node_termination_handler_helm_chart_version"></a> [node\_termination\_handler\_helm\_chart\_version](#input\_node\_termination\_handler\_helm\_chart\_version) | Spot termination handler Helm chart version. | `string` | `"1.12.7"` | no |
| <a name="input_node_termination_handler_namespace"></a> [node\_termination\_handler\_namespace](#input\_node\_termination\_handler\_namespace) | Kubernetes namespace to deploy Spot termination handler Helm chart. | `string` | `"kube-system"` | no |
| <a name="input_node_termination_handler_settings"></a> [node\_termination\_handler\_settings](#input\_node\_termination\_handler\_settings) | Additional settings which will be passed to the Helm chart values. | `map(any)` | `{}` | no |
| <a name="input_prometheus_chart_version"></a> [prometheus\_chart\_version](#input\_prometheus\_chart\_version) | Promtheus Helm chart version. | `string` | `"55.5.0"` | no |
| <a name="input_prometheus_grafana_enabled"></a> [prometheus\_grafana\_enabled](#input\_prometheus\_grafana\_enabled) | Variable indicating whether deployment is enabled. | `bool` | `false` | no |
| <a name="input_prometheus_grafana_namespace"></a> [prometheus\_grafana\_namespace](#input\_prometheus\_grafana\_namespace) | Prometheus Helm chart namespace which the service will be created. | `string` | `"monitoring"` | no |
| <a name="input_prometheus_grafana_settings"></a> [prometheus\_grafana\_settings](#input\_prometheus\_grafana\_settings) | Additional settings which will be passed to the Helm chart values, see https://prometheus-community.github.io/helm-charts | `map(any)` | `{}` | no |
| <a name="input_prometheus_helm_chart_name"></a> [prometheus\_helm\_chart\_name](#input\_prometheus\_helm\_chart\_name) | Prometheus Helm chart name. | `string` | `"kube-prometheus-stack"` | no |
| <a name="input_prometheus_helm_chart_repo"></a> [prometheus\_helm\_chart\_repo](#input\_prometheus\_helm\_chart\_repo) | Promtheus Helm repository name. | `string` | `"https://prometheus-community.github.io/helm-charts"` | no |
| <a name="input_prometheus_metrics_server_chart_version"></a> [prometheus\_metrics\_server\_chart\_version](#input\_prometheus\_metrics\_server\_chart\_version) | Promtheus Helm chart version. | `string` | `"23.0.0"` | no |
| <a name="input_prometheus_metrics_server_enabled"></a> [prometheus\_metrics\_server\_enabled](#input\_prometheus\_metrics\_server\_enabled) | Variable indicating whether deployment is enabled. | `bool` | `false` | no |
| <a name="input_prometheus_metrics_server_helm_chart_name"></a> [prometheus\_metrics\_server\_helm\_chart\_name](#input\_prometheus\_metrics\_server\_helm\_chart\_name) | Prometheus Helm chart name. | `string` | `"prometheus"` | no |
| <a name="input_prometheus_metrics_server_helm_chart_repo"></a> [prometheus\_metrics\_server\_helm\_chart\_repo](#input\_prometheus\_metrics\_server\_helm\_chart\_repo) | Promtheus Helm repository name. | `string` | `"https://prometheus-community.github.io/helm-charts"` | no |
| <a name="input_prometheus_metrics_server_namespace"></a> [prometheus\_metrics\_server\_namespace](#input\_prometheus\_metrics\_server\_namespace) | VPC CNI Helm chart namespace which the service will be created. | `string` | `"monitoring"` | no |
| <a name="input_prometheus_metrics_server_release_name"></a> [prometheus\_metrics\_server\_release\_name](#input\_prometheus\_metrics\_server\_release\_name) | Prometheus Helm chart release name. | `string` | `"prometheus"` | no |
| <a name="input_prometheus_release_name"></a> [prometheus\_release\_name](#input\_prometheus\_release\_name) | Prometheus Helm chart release name. | `string` | `"prometheus_grafana_stack"` | no |
| <a name="input_prometheus_settings"></a> [prometheus\_settings](#input\_prometheus\_settings) | Additional settings which will be passed to the Helm chart values, see https://github.com/aws/eks-charts/tree/master/stable/aws-vpc-cni. | `map(any)` | `{}` | no |
| <a name="input_prometheus_workspace_alias"></a> [prometheus\_workspace\_alias](#input\_prometheus\_workspace\_alias) | Name of amazon managed prometheus workspace. | `string` | `"prometheus-terraform-workspace"` | no |
| <a name="input_provider_arn"></a> [provider\_arn](#input\_provider\_arn) | providerarn | `string` | `""` | no |
| <a name="input_rancher_bootstrapPassword"></a> [rancher\_bootstrapPassword](#input\_rancher\_bootstrapPassword) | Setup initial password while deploy rancher | `string` | `"admin"` | no |
| <a name="input_rancher_chart_name"></a> [rancher\_chart\_name](#input\_rancher\_chart\_name) | Rancher Helm chart name. | `string` | `"rancher"` | no |
| <a name="input_rancher_domain"></a> [rancher\_domain](#input\_rancher\_domain) | Domain for rancer to UI access | `string` | n/a | yes |
| <a name="input_rancher_enabled"></a> [rancher\_enabled](#input\_rancher\_enabled) | Variable indicating whether deployment is enabled. | `bool` | `false` | no |
| <a name="input_rancher_namespace"></a> [rancher\_namespace](#input\_rancher\_namespace) | Kubernetes namespace to deploy rancher Helm chart. | `string` | `"kube-system"` | no |
| <a name="input_rancher_repository"></a> [rancher\_repository](#input\_rancher\_repository) | Rancher Helm repository name. | `string` | `"https://releases.rancher.com/server-charts/latest"` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher Helm chart version. | `string` | `"2.8.0"` | no |
| <a name="input_region"></a> [region](#input\_region) | Indicates where EKS cluster located (default value us-east-1) | `string` | `"us-east-1"` | no |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | Name of route 53 for external dns | `string` | `""` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Additional settings which will be passed to the Helm chart values. | `map` | `{}` | no |
| <a name="input_velero_bucket_name"></a> [velero\_bucket\_name](#input\_velero\_bucket\_name) | Name of bucket created for velero addons | `string` | `"valero-test-bucket-id1234023123"` | no |
| <a name="input_velero_chart_version"></a> [velero\_chart\_version](#input\_velero\_chart\_version) | Velero chart version to use for the velero addons(i.e.: `4.1.3`) | `string` | `"4.1.3"` | no |
| <a name="input_velero_enabled"></a> [velero\_enabled](#input\_velero\_enabled) | Enable velero add-ons | `bool` | `false` | no |
| <a name="input_velero_irsa_role_name"></a> [velero\_irsa\_role\_name](#input\_velero\_irsa\_role\_name) | Name of IRSA which created for velero addons | `string` | `"VeleroIRSA"` | no |
| <a name="input_vpc_cni_enabled"></a> [vpc\_cni\_enabled](#input\_vpc\_cni\_enabled) | Variable indicating whether deployment is enabled. | `bool` | `false` | no |
| <a name="input_vpc_cni_helm_chart_name"></a> [vpc\_cni\_helm\_chart\_name](#input\_vpc\_cni\_helm\_chart\_name) | VPC CNI Helm chart name. | `string` | `"aws-vpc-cni"` | no |
| <a name="input_vpc_cni_helm_chart_release_name"></a> [vpc\_cni\_helm\_chart\_release\_name](#input\_vpc\_cni\_helm\_chart\_release\_name) | VPC CNI Helm chart release name. | `string` | `"aws-vpc-cni"` | no |
| <a name="input_vpc_cni_helm_chart_repo"></a> [vpc\_cni\_helm\_chart\_repo](#input\_vpc\_cni\_helm\_chart\_repo) | VPC CNI Helm repository name. | `string` | `"https://aws.github.io/eks-charts"` | no |
| <a name="input_vpc_cni_helm_chart_version"></a> [vpc\_cni\_helm\_chart\_version](#input\_vpc\_cni\_helm\_chart\_version) | VPC CNI Helm chart version. | `string` | `""` | no |
| <a name="input_vpc_cni_irsa_role_name"></a> [vpc\_cni\_irsa\_role\_name](#input\_vpc\_cni\_irsa\_role\_name) | Name of IRSA which created for vpc cni | `string` | `"VPCCVIIRSARole"` | no |
| <a name="input_vpc_cni_namespace"></a> [vpc\_cni\_namespace](#input\_vpc\_cni\_namespace) | VPC CNI Helm chart namespace which the service will be created. | `string` | `"kube-system"` | no |
| <a name="input_vpc_cni_service_account_name"></a> [vpc\_cni\_service\_account\_name](#input\_vpc\_cni\_service\_account\_name) | The kubernetes service account name for VPC CNI. | `string` | `"aws-vpc-cni"` | no |
| <a name="input_vpc_cni_settings"></a> [vpc\_cni\_settings](#input\_vpc\_cni\_settings) | Additional settings which will be passed to the Helm chart values, see https://github.com/aws/eks-charts/tree/master/stable/aws-vpc-cni. | `map` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the cluster was provisioned | `string` | n/a | yes |

## Outputs

No outputs.
