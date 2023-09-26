resource "aws_eks_cluster" "asmt_eks_cluster" {
  name     = "${var.tag_product}-${var.tag_environment}-eks"
  role_arn = aws_iam_role.asmt_eks_cluster_role.arn

  version = var.eks_cluster_version

  kubernetes_network_config {
    ip_family = var.eks_ip_family
    service_ipv4_cidr = var.eks_service_ipv4_cidr
  }

  vpc_config {
    subnet_ids              = local.private_subnet_ids
    security_group_ids      = [aws_security_group.asmt_eks_sg.id]
    endpoint_public_access  = true
    endpoint_private_access = false
  }

  tags = merge(
    { Name = "${var.tag_product}-${var.tag_environment}-eks" },
    local.tags
  )

  depends_on = [
    aws_iam_role.asmt_eks_cluster_role,
    aws_security_group.asmt_eks_sg
  ]
}

#resource "aws_eks_addon" "asmt_eks_cluster_addon" {
#  cluster_name = aws_eks_cluster.asmt_eks_cluster.name
#  addon_name   = var.eks_addon_name
#}

resource "aws_iam_role" "asmt_eks_cluster_role" {
  name = "${var.tag_product}-${var.tag_environment}-eks-role"
  assume_role_policy = data.aws_iam_policy_document.assume_eks_policy.json

  tags = merge(
    { Name = "${var.tag_product}-${var.tag_environment}-eks-role" },
    local.tags
  )
}

resource "aws_iam_policy" "lb_policy" {
  name = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("./policies/lb_iam_policy.json")
}

resource "aws_iam_role_policy_attachment" "master_node_policy_attachments" {
  for_each = local.master_node_policy

  policy_arn = each.value
  role       = aws_iam_role.asmt_eks_cluster_role.name
}

resource "aws_security_group" "asmt_eks_sg" {
  vpc_id = local.vpc_id
  name = "${var.tag_product}-${var.tag_environment}-eks-sg"

  tags = merge(
    { Name = "${var.tag_product}-${var.tag_environment}-eks-sg" },
    local.tags
  )
}

resource "aws_security_group_rule" "asmt_eks_sg_rule" {
  for_each = local.eks_seg_rules

  security_group_id = aws_security_group.asmt_eks_sg.id

  cidr_blocks       = each.value.cidr_blocks
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  type              = each.value.type
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
      [for role_arn in local.node_iam_role_arns_non_windows : {
        rolearn  = role_arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups = [
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

