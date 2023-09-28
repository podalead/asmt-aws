output "eks_node_group_arn" {
  value = aws_eks_node_group.asmt_eks_eks_managed_node_group.arn
}

output "eks_node_group_name" {
  value = aws_eks_node_group.asmt_eks_eks_managed_node_group.node_group_name
}

output "eks_node_group_role_arn" {
  value = aws_iam_role.asmt_eks_node_group_role.arn
}
