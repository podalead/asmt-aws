locals {
  tag_product = var.tags['Product']
  tag_environment = var.tags['Environment']

  worker_node_policy = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKS_CNI_Policy"
  ]
}

data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_node_group_policy" {
  statement {
    sid     = "EKSNodeAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "tls_private_key" "ssh_keys" {
  algorithm = "ED25519"
}

resource "aws_s3_object" "private_key" {
  bucket = "asmt-aws-terraform-state-bucket-${data.aws_caller_identity.current.account_id}"
  key    = "${local.tag_environment}/eks/private_ssh_key"

  content = tls_private_key.ssh_keys.private_key_pem
}

resource "aws_key_pair" "lt_keypair" {
  key_name   = "${local.tag_product}-${local.tag_environment}-eks-lt-keypair"
  public_key = tls_private_key.ssh_keys.public_key_openssh

  tags = merge(
    { Name = "${local.tag_product}-${local.tag_environment}-eks-lt-keypair" },
    var.tags
  )
}

resource "aws_eks_node_group" "asmt_eks_eks_managed_node_group" {
  cluster_name    = var.eks_cluster_name
  node_group_name = var.eks_node_group_name
  node_role_arn   = aws_iam_role.asmt_eks_node_group_role.arn
  subnet_ids      = var.vpc_private_subnet_ids
  instance_types  = var.eks_ng_instance_types
  disk_size       = "30"

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
    { Name = var.eks_node_group_name },
    var.tags
  )
}

resource "aws_iam_role" "asmt_eks_node_group_role" {
  name               = var.eks_node_group_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_node_group_policy.json

  tags = merge(
    { Name = var.eks_node_group_role_name },
    var.tags
  )
}

resource "aws_iam_role_policy_attachment" "asmt_eks_node_group_role_policies_att" {
  for_each = toset(local.worker_node_policy)

  role       = aws_iam_role.asmt_eks_node_group_role.name
  policy_arn = each.value
}
