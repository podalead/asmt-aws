locals {
  master_node_policy = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ]

  eks_sg_rules = {
    https_ingress_tcp = {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      type        = "ingress"
    }
    dns_ingress_tcp = {
      cidr_blocks = [var.eks_service_ipv4_cidr]
      from_port   = 53
      to_port     = 53
      protocol    = "tcp"
      type        = "ingress"
    }
    service_ports_tcp = {
      cidr_blocks = [var.eks_service_ipv4_cidr]
      from_port   = 1000
      to_port     = 65535
      protocol    = "tcp"
      type        = "ingress"
    }
    #    http_ingress = {
    #      cidr_blocks = ["0.0.0.0/0"]
    #      from_port   = 80
    #      to_port     = 80
    #      protocol    = "-1"
    #      type        = "ingress"
    #    }
    egress_all = {
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      type        = "egress"
    }
  }
}

data "aws_iam_policy_document" "assume_eks_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_eks_cluster" "asmt_eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.asmt_eks_cluster_role.arn

  version = var.eks_cluster_version

  kubernetes_network_config {
    ip_family         = var.eks_ip_family
    service_ipv4_cidr = var.eks_service_ipv4_cidr
  }

  vpc_config {
    subnet_ids              = var.eks_private_subnet_ids
    security_group_ids      = [aws_security_group.asmt_eks_sg.id]
    endpoint_public_access  = true
    endpoint_private_access = false
  }
  enabled_cluster_log_types = var.eks_log_types

  tags = merge(
    { Name = var.eks_cluster_name },
    var.tags
  )

  depends_on = [
    aws_iam_role.asmt_eks_cluster_role,
    aws_security_group.asmt_eks_sg
  ]
}

resource "aws_iam_policy" "logs_policy" {
  name   = var.eks_cluster_log_policy_name
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        "Resource" : [
          "arn:aws:logs:*:*:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "logs_policy" {
  role       = aws_iam_role.asmt_eks_cluster_role.name
  policy_arn = aws_iam_policy.logs_policy.arn
}

resource "aws_iam_role" "asmt_eks_cluster_role" {
  name               = var.eks_cluster_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_eks_policy.json

  tags = merge(
    { Name = var.eks_cluster_role_name },
    var.tags
  )
}

resource "aws_iam_role_policy_attachment" "master_node_policy_attachments" {
  for_each = toset(local.master_node_policy)

  policy_arn = each.value
  role       = aws_iam_role.asmt_eks_cluster_role.name
}

resource "aws_security_group" "asmt_eks_sg" {
  name = var.eks_cluster_sg_name

  vpc_id = var.vpc_id

  tags = merge(
    {
      Name                                            = var.eks_cluster_sg_name
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    },
    var.tags
  )
}

resource "aws_security_group_rule" "asmt_eks_sg_rule" {
  for_each = local.eks_sg_rules

  security_group_id = aws_security_group.asmt_eks_sg.id

  cidr_blocks = each.value.cidr_blocks
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  type        = each.value.type
}
