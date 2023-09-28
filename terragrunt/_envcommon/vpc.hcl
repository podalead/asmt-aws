locals {
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  base_source_url  = "../../modules/vpc"
}

inputs = {
  vpc_cidr             = "10.0.0.0/16"
  azs                  = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  product     = local.account_vars.locals.product
  environment = local.environment_vars.locals.environment

  tags = {
    Contact     = local.account_vars.locals.contact
    Cost_Code   = local.account_vars.locals.cost_code
    Environment = local.environment_vars.locals.environment
    Provisioner = local.account_vars.locals.provisioner
  }
}
