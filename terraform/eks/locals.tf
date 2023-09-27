locals {
  eks_basename = "${var.tag_product}-${var.tag_environment}"
  eks_cluster_name = "${local.eks_basename}-eks"
  eks_cluster_role_name = "${local.eks_basename}-eks-role"
  eks_cluster_idp_role_name = "${local.eks_basename}-oidc-provider-role"
  eks_cluster_idp_name = "${local.eks_basename}-oidc-provider"
  eks_cluster_sg_name = "${local.eks_basename}-eks-sg"
  eks_node_group_name = "${local.eks_basename}-eks-node-group"
  eks_node_group_role_name = "${local.eks_basename}-eks-node-group-iam-role"
  eks_cluster_log_policy_name = "${local.eks_basename}-log-policy"

  eks_cluster_oidc_issuer = aws_eks_cluster.asmt_eks_cluster.identity[0].oidc[0].issuer
  oidc_uri = replace(aws_iam_openid_connect_provider.demo.url, "https://", "")

  default_tags = {
    Contact     = var.tag_contact
    Cost_Code   = var.tag_cost_code
    Environment = var.tag_environment
    Provisioner = var.tag_provisioner
  }

  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.vpc.outputs.vpc_private_subnet_ids

  worker_node_policy = toset([
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonEKS_CNI_Policy"
  ])

  master_node_policy = toset([
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  ])

  eks_seg_rules = {
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
