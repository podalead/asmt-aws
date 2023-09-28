locals {
  eks_basename                = "${var.tag_product}-${var.tag_environment}"
  eks_cluster_name            = "${local.eks_basename}-eks"
  eks_cluster_sg_name         = "${local.eks_basename}-eks-sg"
  eks_cluster_role_name       = "${local.eks_basename}-eks-role"
  eks_node_group_name         = "${local.eks_basename}-eks-node-group"
  eks_node_group_role_name    = "${local.eks_basename}-eks-node-group-iam-role"
  eks_cluster_idp_role_name   = "${local.eks_basename}-oidc-provider-role"
  eks_cluster_idp_name        = "${local.eks_basename}-oidc-provider"
  eks_cluster_log_policy_name = "${local.eks_basename}-log-policy"

  default_tags = {
    Contact     = var.tag_contact
    Cost_Code   = var.tag_cost_code
    Environment = var.tag_environment
    Provisioner = var.tag_provisioner
  }
}

module "vpc" {
  source = "../modules/vpc"

  vpc_cidr = var.vpc_cidr
  azs      = var.azs

  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs

  product     = var.tag_product
  environment = var.tag_environment
  tags        = local.default_tags
}

module "eks_master" {
  source = "../modules/eks-cluster"
  vpc_id = module.vpc.vpc_id

  eks_cluster_name       = local.eks_cluster_name
  eks_cluster_version    = var.eks_cluster_version
  eks_service_ipv4_cidr  = var.eks_service_ipv4_cidr
  eks_private_subnet_ids = module.vpc.vpc_private_subnet_ids

  eks_cluster_sg_name         = local.eks_cluster_sg_name
  eks_cluster_role_name       = local.eks_cluster_role_name
  eks_cluster_log_policy_name = local.eks_cluster_log_policy_name

  tags = local.default_tags
}

module "eks_simple_node_group" {
  source = "../modules/eks-simple-node-group"

  eks_cluster_name       = module.eks_master.eks_cluster_name
  eks_node_group_name    = local.eks_node_group_name
  vpc_private_subnet_ids = module.vpc.vpc_private_subnet_ids

  eks_node_group_role_name = local.eks_node_group_role_name

  tags = local.default_tags

  depends_on = [
    module.eks_master
  ]
}

module "eks_oidc" {
  source = "../modules/eks-idp"

  eks_cluster_name          = module.eks_master.eks_cluster_name
  eks_cluster_idp_name      = local.eks_cluster_idp_name
  eks_cluster_idp_role_name = local.eks_cluster_idp_role_name

  eks_cluster_client_id   = module.eks_master.eks_cluster_client_id
  eks_cluster_oidc_issuer = module.eks_master.eks_cluster_oidc_issuer

  tags = local.default_tags

  depends_on = [
    module.eks_simple_node_group
  ]
}

module "eks_lb_controller" {
  source = "../modules/eks-lb-controller"

  eks_cluster_name     = module.eks_master.eks_cluster_name
  eks_lb_addon_version = var.eks_addon_lb_version

  eks_oidc_role_arn  = module.eks_oidc.eks_oidc_role_arn
  eks_oidc_role_name = module.eks_oidc.eks_oidc_role_name

  tags = local.default_tags
}

################################################################################
# aws-auth configmap
################################################################################
locals {
  node_iam_role_arns_non_windows = distinct(
    compact(
      concat(
        [module.eks_simple_node_group.eks_node_group_role_arn],
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

