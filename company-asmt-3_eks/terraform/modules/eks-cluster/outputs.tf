output "eks_cluster_id" {
  value = aws_eks_cluster.asmt_eks_cluster.cluster_id
}

output "eks_cluster_client_id" {
  value = substr(aws_eks_cluster.asmt_eks_cluster.identity[0].oidc[0].issuer, -32, -1)
}

output "eks_cluster_arn" {
  value = aws_eks_cluster.asmt_eks_cluster.arn
}

output "eks_cluster_name" {
  value = aws_eks_cluster.asmt_eks_cluster.name
}

output "eks_cluster_host" {
  value = aws_eks_cluster.asmt_eks_cluster.endpoint
}

output "eks_cluster_ca_certificate" {
  value = aws_eks_cluster.asmt_eks_cluster.certificate_authority[0].data
}

output "eks_cluster_oidc_issuer" {
  value = aws_eks_cluster.asmt_eks_cluster.identity[0].oidc[0].issuer
}

output "eks_cluster_sg_id" {
  value = aws_security_group.asmt_eks_sg.id
}

output "eks_cluster_sg_name" {
  value = aws_security_group.asmt_eks_sg.name
}

output "eks_cluster_role_arn" {
  value = aws_security_group.asmt_eks_sg.arn
}

output "eks_cluster_role_name" {
  value = aws_eks_cluster.asmt_eks_cluster.name
}
