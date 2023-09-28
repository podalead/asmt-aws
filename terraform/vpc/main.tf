locals {
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
