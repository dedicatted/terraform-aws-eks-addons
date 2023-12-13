output "velero_bucket_name" {
  value = aws_s3_bucket.velero_bucket.bucket_name
}
output "AlbControllerIRSA_name" {
  value = var.alb_controller_irsa_role_name
}
output "CertManagerIRSA_name" {
  value = var.alb_controller_irsa_role_name
}
output "cluster_autoscaler_irsa_role_name" {
  value = var.cluster_autoscaler_irsa_role_name
}
output "ebs_csi_irsa_role_name" {
  value = var.ebs_csi_irsa_role_name
}
output "external_dns_irsa_role_name" {
  value = var.external_dns_irsa_role_name
}
output "external_secrets_irsa_role_name" {
  value = var.external_secrets_irsa_role_name
}
output "velero_irsa_role_name" {
  value = var.velero_irsa_role_name
}