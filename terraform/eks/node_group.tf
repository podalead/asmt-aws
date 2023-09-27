#resource "aws_launch_template" "asmt_eks_launch_template" {
#  name                   = "${var.tag_product}-${var.tag_environment}-lt"
#  update_default_version = true
#
#  image_id      = data.aws_ami.eks_default.id
#  key_name      = aws_key_pair.lt_keypair.key_name
#  instance_type = "t3a.small"
#  ebs_optimized = true
#
#  tag_specifications {
#    resource_type = "ec2"
#    tags = {
#      "kubernetes.io/cluster/${aws_eks_cluster.asmt_eks_cluster.name}" = "owned"
#      "k8s.io/cluster-autoscaler/${aws_eks_cluster.asmt_eks_cluster.name}" = "owned"
#      "k8s.io/cluster-autoscaler/enabled" = 1
#    }
#  }
#
#  tags = merge(
#    { Name = "${var.tag_product}-${var.tag_environment}-eks-lt" },
#    local.tags
#  )
#
#  depends_on = [
#    aws_key_pair.lt_keypair
#  ]
#}

resource "tls_private_key" "ssh_keys" {
  algorithm = "ED25519"
}

resource "aws_s3_object" "private_key" {
  bucket = "asmt-aws-terraform-state-bucket-${data.aws_caller_identity.current.account_id}"
  key    = "${var.tag_environment}/eks/private_ssh_key"

  content = tls_private_key.ssh_keys.private_key_pem
}

resource "aws_key_pair" "lt_keypair" {
  key_name   = "${var.tag_product}-${var.tag_environment}-eks-lt-keypair"
  public_key = tls_private_key.ssh_keys.public_key_openssh

  tags = merge(
    { Name = "${var.tag_product}-${var.tag_environment}-eks-lt-keypair" },
    local.default_tags
  )
}

resource "aws_eks_node_group" "asmt_eks_eks_managed_node_group" {
  node_group_name      = local.eks_node_group_name
  cluster_name         = aws_eks_cluster.asmt_eks_cluster.name
  node_role_arn        = aws_iam_role.asmt_eks_node_group_role.arn
  subnet_ids           = data.terraform_remote_state.vpc.outputs.vpc_private_subnet_ids
  instance_types       = ["t3a.small", "t3.small"]
  disk_size            = "30"

  scaling_config {
    min_size     = 1
    desired_size = 2
    max_size     = 3
  }

  #  launch_template {
  #    version = "$Latest"
  #    name    = aws_launch_template.asmt_eks_launch_template.name
  #  }

  tags = merge(
    { Name = local.eks_node_group_name },
    local.default_tags
  )
}

resource "aws_iam_role" "asmt_eks_node_group_role" {
  name               = local.eks_node_group_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_node_group_policy.json

  tags = merge(
    { Name = local.eks_node_group_role_name },
    local.default_tags
  )
}

resource "aws_iam_role_policy_attachment" "asmt_eks_node_group_role_policies_att" {
  for_each = local.worker_node_policy

  role       = aws_iam_role.asmt_eks_node_group_role.name
  policy_arn = each.value
}
