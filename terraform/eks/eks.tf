resource "aws_eks_cluster" "asmt_eks_cluster" {
  name     = local.eks_cluster_name
  role_arn = aws_iam_role.asmt_eks_cluster_role.arn

  version = var.eks_cluster_version

  kubernetes_network_config {
    ip_family         = var.eks_ip_family
    service_ipv4_cidr = var.eks_service_ipv4_cidr
  }

  vpc_config {
    subnet_ids              = local.private_subnet_ids
    security_group_ids      = [aws_security_group.asmt_eks_sg.id]
    endpoint_public_access  = true
    endpoint_private_access = false
  }
  enabled_cluster_log_types = var.eks_log_types

  tags = merge(
    { Name = local.eks_cluster_name },
    local.default_tags
  )

  depends_on = [
    aws_iam_role.asmt_eks_cluster_role,
    aws_security_group.asmt_eks_sg
  ]
}

resource "aws_iam_policy" "logs_policy" {
  name   = local.eks_cluster_log_policy_name
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
  name               = local.eks_cluster_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_eks_policy.json

  tags = merge(
    { Name = local.eks_cluster_role_name },
    local.default_tags
  )
}

resource "aws_iam_role_policy_attachment" "master_node_policy_attachments" {
  for_each = local.master_node_policy

  policy_arn = each.value
  role       = aws_iam_role.asmt_eks_cluster_role.name
}

resource "aws_security_group" "asmt_eks_sg" {
  name = local.eks_cluster_sg_name

  vpc_id = local.vpc_id

  tags = merge(
    {
      Name                                              = local.eks_cluster_sg_name
      "kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
    },
    local.default_tags
  )
}

resource "aws_security_group" "asmt_alb_sg" {
  name   = local.alb_security_group_name
  vpc_id = local.vpc_id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }

  dynamic "ingress" {
    for_each = {
      http         = 80
      https        = 443
      http_second  = 8080
      https_second = 8443
    }

    content {
      cidr_blocks = ["0.0.0.0/0"]
      protocol    = "tcp"
      from_port   = ingress.value
      to_port     = ingress.value
    }
  }

  tags = merge(
    {
      Name                                              = local.alb_security_group_name
      "kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
    },
    local.default_tags
  )
}

resource "aws_security_group_rule" "asmt_eks_sg_rule_ingress_alb" {
  security_group_id = aws_security_group.asmt_eks_sg.id

  source_security_group_id = aws_security_group.asmt_alb_sg.id
  from_port                = 1000
  to_port                  = 65535
  protocol                 = "TCP"
  type                     = "ingress"
}

resource "aws_security_group_rule" "asmt_eks_sg_rule" {
  for_each = local.eks_seg_rules

  security_group_id = aws_security_group.asmt_eks_sg.id

  cidr_blocks = each.value.cidr_blocks
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  type        = each.value.type
}

################################################################################
# aws-auth configmap
################################################################################
locals {
  node_iam_role_arns_non_windows = distinct(
    compact(
      concat(
        [aws_iam_role.asmt_eks_node_group_role.arn],
        var.aws_auth_node_iam_role_arns_non_windows,
      )
    )
  )

  aws_auth_configmap_data = {
    mapRoles = yamlencode(concat(
      [
        for role_arn in local.node_iam_role_arns_non_windows : {
        rolearn  = role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = [
          "system:bootstrappers",
          "system:nodes",
        ]
      }
      ],
      var.aws_auth_roles
    ))
    mapUsers    = yamlencode(var.aws_auth_users)
    mapAccounts = yamlencode(var.aws_auth_accounts)
  }
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = local.aws_auth_configmap_data

  lifecycle {
    ignore_changes = [data, metadata[0].labels, metadata[0].annotations]
  }
}

resource "kubernetes_config_map_v1_data" "aws_auth" {
  force = true

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = local.aws_auth_configmap_data

  depends_on = [kubernetes_config_map.aws_auth]
}

