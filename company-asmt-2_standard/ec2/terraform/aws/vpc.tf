module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.network_cidr_block

  azs             = var.availability_zones
  public_subnets  = var.network_cidr_public_block
  private_subnets = var.network_cidr_private_block
  database_subnets = var.network_cidr_database_block

  enable_nat_gateway = true
  single_nat_gateway   = false
  reuse_nat_ips        = false
  enable_vpn_gateway   = false
  enable_dns_hostnames = true

  tags = {
    Environment = var.profile
  }
}