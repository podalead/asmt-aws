resource "aws_subnet" "public" {
  count = local.length_public_subnets

  availability_zone                              = element(var.azs, count.index)
  cidr_block                                     = element(var.public_subnet_cidrs, count.index)
  map_public_ip_on_launch                        = false
  vpc_id                                         = local.vpc_id

  tags = merge(
    {
      Name = format("%s-%s-public-subnet-%s", var.tag_product, var.tag_environment, count.index)
      "kubernetes.io/role/elb" = 1
      Type = "public"
    },
    local.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = local.vpc_id

  tags = merge(
    {
      Name = format("%s-%s-public-rt", var.tag_product, var.tag_environment)
    },
    local.tags
  )
}

resource "aws_route_table_association" "public" {
  count = local.length_public_subnets

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route" "public_internet_gateway_ipv6" {

  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.this.id
}



