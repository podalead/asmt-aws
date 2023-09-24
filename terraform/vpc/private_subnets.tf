resource "aws_subnet" "private" {
  count = local.length_private_subnets

  availability_zone                              = element(var.azs, count.index)
  cidr_block                                     = element(var.private_subnet_cidrs, count.index)
  map_public_ip_on_launch                        = false
  private_dns_hostname_type_on_launch            = false
  vpc_id                                         = local.vpc_id

  tags = merge(
    {
      Name = format("%s-%s-public-subnet-%s", var.tag_product, var.tag_environment, count.index)
      Type = "private"
    },
    local.tags
  )
}

resource "aws_route_table" "private" {
  vpc_id = local.vpc_id

  tags = merge(
    {
      Name = format("%s-%s-private-rt", var.tag_product, var.tag_environment)
    },
    local.tags
  )
}

resource "aws_route_table_association" "private" {
  count = local.length_private_subnets

  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private[0].id
}



