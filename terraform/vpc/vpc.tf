resource "aws_vpc" "asmt_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_support = true

  tags = merge(
    { Name = "${var.tag_product}-${var.tag_environment}-vpc" },
    local.tags
  )
}
