### TAGS ###
tag_product     = "asmt"
tag_contact     = "Mykhail Poda"
tag_cost_code   = "00001"
tag_environment = "dev"
tag_provisioner = "github"

### VPC ###
vpc_cidr             = "10.0.0.0/16"
region               = "eu-west-1"
azs                  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

### EKS ###
eks_cluster_version    = "1.27"
eks_addon_lb_version   = "2.5.4"
eks_ip_family          = "ipv4"
eks_service_ipv4_cidr  = "192.168.1.0/24"
eks_addon_name         = "vpc-cni"
eks_node_instance_type = "t3a.small"
eks_log_types          = ["api", "audit", "controllerManager"]

aws_auth_roles = [
  {
    groups : ["system:masters"],
    rolearn : "arn:aws:iam::270930892402:role/github-connection-provider-role"
    username : "github-admin"
  },
  {
    groups : ["system:masters"],
    rolearn : "arn:aws:iam::270930892402:role/AWSReservedSSO_AdministratorAccess_2546bd6cb177278c",
    username : "cluster-admin"
  }
]
aws_auth_accounts = [
  270930892402
]
