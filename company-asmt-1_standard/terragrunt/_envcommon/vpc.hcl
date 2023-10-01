locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env = local.environment_vars.locals.environment
  base_source_url = "tfr:///terraform-aws-modules/vpc/aws"
}

inputs = {
  name = format("headway-vpc-%s", local.env)
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-3a", "eu-west-3b"]
  private_subnets = ["10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  enable_vpn_gateway = false
  enable_dns_hostnames = true

  tags = {
    Environment = "${local.env}"
    Created_by = "Mykhail Poda"
  }
}