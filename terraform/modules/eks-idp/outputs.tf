output "eks_oidc_arn" {
  value = aws_iam_openid_connect_provider.demo.arn
}

output "eks_oidc_role_arn" {
  value = aws_iam_role.aws-node.arn
}

output "eks_oidc_role_name" {
  value = aws_iam_role.aws-node.name
}
