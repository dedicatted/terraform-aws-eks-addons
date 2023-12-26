data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_eks_cluster" "eks_cluster" {
  name = var.cluster_name
}
data "aws_route53_zone" "external_dns_zone_name" {
  count      = var.external_dns_enabled ? 1 : 0
  name = var.route53_zone_name
}