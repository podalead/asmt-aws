locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env = local.environment_vars.locals.environment
  base_source_url = "tfr:///terraform-aws-modules/security-group/aws"
}

inputs = {
  name = format("headway-alb-sg-%s", local.env)

  description = "Security group for web-app with HTTP ports open within VPC"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]

  tags = {
    Name = format("headway-alb-sg-%s", local.env)
    Environment = "${local.env}"
    Created_by = "Mykhail Poda"
  }
}