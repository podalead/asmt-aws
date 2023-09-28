output "eks_cluster_name" {
  value = aws_eks_cluster.asmt_eks_cluster.name
}

output "eks_host" {
  value = aws_eks_cluster.asmt_eks_cluster.endpoint
}

output "eks_ca_cert_base64" {
  value = aws_eks_cluster.asmt_eks_cluster.certificate_authority.0.data
}

output "eks_oidc_arn" {
  value = aws_eks_identity_provider_config.demo.arn
}

output "eks_alb_sg_id" {
  value = aws_security_group.asmt_alb_sg.id
}
