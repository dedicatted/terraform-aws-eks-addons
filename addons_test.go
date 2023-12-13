package test

import (
	"testing"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestEKSAddons(t *testing.T) {
	awsRegion := "us-east-1"
	EksTerraformOptions := &terraform.Options{
		TerraformDir: "some_folder", // TO DO on the next interation when implement test.
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}
	terraform.InitAndApply(t, EksTerraformOptions)

	key_arn := terraform.Output(t, EksTerraformOptions, "kms_key_arn")
	vpcID := terraform.Output(t, EksTerraformOptions, "test_vpc_id")
    oidc_provider_arn := terraform.Output(t, EksTerraformOptions, "test_oidc_provider_arn")
    cluster_name := terraform.Output(t, EksTerraformOptions, "test_cluster_name")
    eks_cluster_endpoint := terraform.Output(t, EksTerraformOptions, "eks_cluster_endpoint")
    eks_cluster_certificate := terraform.Output(t, EksTerraformOptions, "CA")

    EksAddonsterraformOptions := &terraform.Options{
		TerraformDir: "./terraform-aws-eks-addons",
		Vars: map[string]interface{}{
			"oidc_provider_arn": oidc_provider_arn,
			"cluster_name": cluster_name,
			"eks_cluster_endpoint": eks_cluster_endpoint,
			"eks_cluster_certificate": eks_cluster_certificate,
			"route53_zone_name": "testterraform.com",
			"kms_key_arn": key_arn,
			"vpc_id": vpcID,
			"cluster_autoscaler_enabled": true,
			"external_dns_enabled": true,
			"aws_load_balancer_controller_enabled": true,
			"valero_enabled": true,
			"aws_ebs_csi_driver_enabled": true,
			"external_secrets_enabled": true,
			"external_secrets_kms_key_arn":  []string{key_arn},
		},
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": awsRegion,
		},
	}
	terraform.InitAndApply(t, EksAddonsterraformOptions)
	defer terraform.Destroy(t, EksTerraformOptions)
	defer terraform.Destroy(t, EksAddonsterraformOptions)
}