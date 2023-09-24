locals {
  length_private_subnets = length(var.private_subnet_cidrs)
  length_public_subnets = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.asmt_vpc.id

  tags = {
    Contact     = var.tag_contact
    Cost_Code   = var.tag_cost_code
    Environment = var.tag_environment
    Provisioner = var.tag_provisioner
  }
}
