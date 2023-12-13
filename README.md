# Terraform Module: terraform-aws-eks-addons
# This module facilitates deployment of AWS EKS Addons via terraform in existing EKS cluster.

## Overview
The 'terraform-aws-eks-addons' module streamlines the deployment of essential add-ons and configurations for Amazon EKS (Elastic Kubernetes Service) infrastructure using Terraform. This module is designed to facilitate the incorporation of key components that enhance the functionality and management of your EKS cluster. This module contains list of addons : Velere, External Secret, External DNS, EBS CSI Drive, Cluster Autoscaler, Cert Manager, Load Balancer Controller
## Usage
```hcl
//Configuration to call the module
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
```
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
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.30.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.12.1 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | 0.10.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cert_manager_irsa_role"></a> [cert\_manager\_irsa\_role](#module\_cert\_manager\_irsa\_role) | ../../modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_cluster_autoscaler_irsa_role"></a> [cluster\_autoscaler\_irsa\_role](#module\_cluster\_autoscaler\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_ebs_csi_irsa_role"></a> [ebs\_csi\_irsa\_role](#module\_ebs\_csi\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_external_dns_irsa_role"></a> [external\_dns\_irsa\_role](#module\_external\_dns\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_external_secrets_irsa_role"></a> [external\_secrets\_irsa\_role](#module\_external\_secrets\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_kms_key_csi"></a> [kms\_key\_csi](#module\_kms\_key\_csi) | github.com/dedicatted/devops-tech//terraform/aws/modules/terraform-aws-kms | n/a |
| <a name="module_load_balancer_controller_irsa_role"></a> [load\_balancer\_controller\_irsa\_role](#module\_load\_balancer\_controller\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |
| <a name="module_velero_irsa_role"></a> [velero\_irsa\_role](#module\_velero\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.velero_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [helm_release.alb_ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ebs_csi_driver](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external_secrets](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.velero](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.external_secrets_cluster_store](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [random_pet.bucket_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [time_sleep.wait_for_external_dns](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_for_external_secrets](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.wait_for_load_balancer_and_route53_record](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_chart_version"></a> [alb\_chart\_version](#input\_alb\_chart\_version) | ALB controller chart version to use for the ALB controller addons(i.e.: `1.5.4`) | `string` | `"1.5.4"` | no |
| <a name="input_alb_controller_irsa_role_name"></a> [alb\_controller\_irsa\_role\_name](#input\_alb\_controller\_irsa\_role\_name) | Name of IRSA which created for application load balancer controller addons | `string` | `"AlbControllerIRSA"` | no |
| <a name="input_autoscaler_chart_version"></a> [autoscaler\_chart\_version](#input\_autoscaler\_chart\_version) | Cluster autoscaler chart version to use for the cluster autoscaler addons (i.e.: 9.29.1) | `string` | `"9.29.1"` | no |
| <a name="input_aws_ebs_csi_driver_enabled"></a> [aws\_ebs\_csi\_driver\_enabled](#input\_aws\_ebs\_csi\_driver\_enabled) | Enable ebs csi add-ons | `bool` | `false` | no |
| <a name="input_aws_load_balancer_controller_enabled"></a> [aws\_load\_balancer\_controller\_enabled](#input\_aws\_load\_balancer\_controller\_enabled) | Enable load balancer controller add-ons | `bool` | `false` | no |
| <a name="input_cert_manager_enabled"></a> [cert\_manager\_enabled](#input\_cert\_manager\_enabled) | Variable indicating whether deployment is enabled. | `bool` | `true` | no |
| <a name="input_cert_manager_hosted_zone_arn"></a> [cert\_manager\_hosted\_zone\_arn](#input\_cert\_manager\_hosted\_zone\_arn) | List of hosted zone arns which would be managed by cert manager | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_cert_manager_irsa_role_name"></a> [cert\_manager\_irsa\_role\_name](#input\_cert\_manager\_irsa\_role\_name) | Name of IRSA which created for cert manager addons | `string` | `"CertManagerIRSA"` | no |
| <a name="input_cluster_autoscaler_enabled"></a> [cluster\_autoscaler\_enabled](#input\_cluster\_autoscaler\_enabled) | Enable cluster autoscaler add-ons | `bool` | `false` | no |
| <a name="input_cluster_autoscaler_irsa_role_name"></a> [cluster\_autoscaler\_irsa\_role\_name](#input\_cluster\_autoscaler\_irsa\_role\_name) | Name of IRSA which created for cluster autoscaler addons | `string` | `"ClusterAutoscalerIRSA"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | AWS EKS cluster name with which terraform works | `string` | n/a | yes |
| <a name="input_cluster_secret_store_name"></a> [cluster\_secret\_store\_name](#input\_cluster\_secret\_store\_name) | Define name of cluster secret store custom resource | `string` | `"TerraformClusterSecretStore"` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Whether to create Kubernetes namespace with name defined by `namespace`. | `bool` | `true` | no |
| <a name="input_ebs_chart_version"></a> [ebs\_chart\_version](#input\_ebs\_chart\_version) | EBS chart version to use for the ebs addons(i.e.: `2.20.0`) | `string` | `"2.20.0"` | no |
| <a name="input_ebs_csi_irsa_role_name"></a> [ebs\_csi\_irsa\_role\_name](#input\_ebs\_csi\_irsa\_role\_name) | Name of IRSA which created for ebs csi addons | `string` | `"EbsCsiIRSA"` | no |
| <a name="input_ebs_csi_kms_key_arn"></a> [ebs\_csi\_kms\_key\_arn](#input\_ebs\_csi\_kms\_key\_arn) | KMS key arn which will be use for encrypt EBS volume y eks ebs csi addons | `string` | `""` | no |
| <a name="input_ebs_csi_reclaimepolicy"></a> [ebs\_csi\_reclaimepolicy](#input\_ebs\_csi\_reclaimepolicy) | The reclaim policy for a PersistentVolume tells the cluster what to do with the volume after it has been released of its claim. Got 3 option: Retained, Recycled, or Deleted | `string` | `"Delete"` | no |
| <a name="input_eks_cluster_certificate"></a> [eks\_cluster\_certificate](#input\_eks\_cluster\_certificate) | Cluster certicate which give ability to work with cluster | `string` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | Cluster endpoint which give ability to work with cluster | `string` | n/a | yes |
| <a name="input_external_dns_chart_version"></a> [external\_dns\_chart\_version](#input\_external\_dns\_chart\_version) | External DNS chart version to use for the external DNS addons(i.e.: `6.20.4`) | `string` | `"6.20.4"` | no |
| <a name="input_external_dns_enabled"></a> [external\_dns\_enabled](#input\_external\_dns\_enabled) | Enable external dns add-ons | `bool` | `false` | no |
| <a name="input_external_dns_irsa_role_name"></a> [external\_dns\_irsa\_role\_name](#input\_external\_dns\_irsa\_role\_name) | Name of IRSA which created for external DNS addons | `string` | `"ExternalDNSIRSA"` | no |
| <a name="input_external_secrets_chart_version"></a> [external\_secrets\_chart\_version](#input\_external\_secrets\_chart\_version) | External secrets chart version to use for the external secrets addons(i.e.: `0.9.0`) | `string` | `"0.9.9"` | no |
| <a name="input_external_secrets_enabled"></a> [external\_secrets\_enabled](#input\_external\_secrets\_enabled) | Enable external secret add-ons | `bool` | `false` | no |
| <a name="input_external_secrets_irsa_role_name"></a> [external\_secrets\_irsa\_role\_name](#input\_external\_secrets\_irsa\_role\_name) | Name of IRSA which created for external secret addons | `string` | `"ExternalSecretIRSA"` | no |
| <a name="input_external_secrets_kms_key_arn"></a> [external\_secrets\_kms\_key\_arn](#input\_external\_secrets\_kms\_key\_arn) | KMS key arn which use Parameter Store or Secret manager | `list(string)` | <pre>[<br>  ""<br>]</pre> | no |
| <a name="input_extrenal_secret_store"></a> [extrenal\_secret\_store](#input\_extrenal\_secret\_store) | Defined which secret manager used in ClusterSecretStore (ParametesStore or SecretStore) | `string` | `"SecretStore"` | no |
| <a name="input_helm_chart_name"></a> [helm\_chart\_name](#input\_helm\_chart\_name) | Cert Manager Helm chart name to be installed | `string` | `"cert-manager"` | no |
| <a name="input_helm_chart_release_name"></a> [helm\_chart\_release\_name](#input\_helm\_chart\_release\_name) | Helm release name | `string` | `"cert-manager"` | no |
| <a name="input_helm_chart_repo"></a> [helm\_chart\_repo](#input\_helm\_chart\_repo) | Cert Manager repository name. | `string` | `"https://charts.jetstack.io"` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | Cert Manager Helm chart version. | `string` | `"1.1.0"` | no |
| <a name="input_install_CRDs"></a> [install\_CRDs](#input\_install\_CRDs) | To automatically install and manage the CRDs as part of your Helm release. | `bool` | `true` | no |
| <a name="input_oidc_provider_arn"></a> [oidc\_provider\_arn](#input\_oidc\_provider\_arn) | AWS EKS cluster oidc provider arn | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Indicates where EKS cluster located (default value us-east-1) | `string` | `"us-east-1"` | no |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | Name of route 53 for external dns | `string` | "" | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Additional settings which will be passed to the Helm chart values. | `map` | `{}` | no |
| <a name="input_velero_bucket_name"></a> [velero\_bucket\_name](#input\_velero\_bucket\_name) | Name of bucket created for velero addons | `string` | `"qwerqwerqewrqwerqewr"` | no |
| <a name="input_velero_chart_version"></a> [velero\_chart\_version](#input\_velero\_chart\_version) | Velero chart version to use for the velero addons(i.e.: `4.1.3`) | `string` | `"4.1.3"` | no |
| <a name="input_velero_enabled"></a> [velero\_enabled](#input\_velero\_enabled) | Enable velero add-ons | `bool` | `false` | no |
| <a name="input_velero_irsa_role_name"></a> [velero\_irsa\_role\_name](#input\_velero\_irsa\_role\_name) | Name of IRSA which created for velero addons | `string` | `"VeleroIRSA"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC where the cluster was provisioned | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_AlbControllerIRSA_name"></a> [AlbControllerIRSA\_name](#output\_AlbControllerIRSA\_name) | n/a |
| <a name="output_CertManagerIRSA_name"></a> [CertManagerIRSA\_name](#output\_CertManagerIRSA\_name) | n/a |
| <a name="output_cluster_autoscaler_irsa_role_name"></a> [cluster\_autoscaler\_irsa\_role\_name](#output\_cluster\_autoscaler\_irsa\_role\_name) | n/a |
| <a name="output_ebs_csi_irsa_role_name"></a> [ebs\_csi\_irsa\_role\_name](#output\_ebs\_csi\_irsa\_role\_name) | n/a |
| <a name="output_external_dns_irsa_role_name"></a> [external\_dns\_irsa\_role\_name](#output\_external\_dns\_irsa\_role\_name) | n/a |
| <a name="output_external_secrets_irsa_role_name"></a> [external\_secrets\_irsa\_role\_name](#output\_external\_secrets\_irsa\_role\_name) | n/a |
| <a name="output_velero_bucket_name"></a> [velero\_bucket\_name](#output\_velero\_bucket\_name) | n/a |
| <a name="output_velero_irsa_role_name"></a> [velero\_irsa\_role\_name](#output\_velero\_irsa\_role\_name) | n/a |

