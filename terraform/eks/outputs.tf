output "eks_endpoint" {
  value = aws_eks_cluster.asmt_eks_cluster.endpoint
}

output "eks_oidc_arn" {
  value = aws_eks_identity_provider_config.demo.arn
}
