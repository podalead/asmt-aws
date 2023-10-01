locals {
  vpc_id = aws_vpc.asmt_vpc.id

  length_public_subnets = length(var.public_subnet_cidrs)
  length_private_subnets = length(var.private_subnet_cidrs)
}

##########################
########## VPC ###########
##########################
resource "aws_vpc" "asmt_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_support = true

  tags = merge(
    { Name = "${var.product}-${var.environment}-vpc" },
    var.tags
  )
}

##########################
### PUBLIC SUBNETWORKS ###
##########################
resource "aws_subnet" "public" {
  count = local.length_public_subnets

  availability_zone                              = element(var.azs, count.index)
  cidr_block                                     = element(var.public_subnet_cidrs, count.index)
  map_public_ip_on_launch                        = false
  vpc_id                                         = local.vpc_id

  tags = merge(
    {
      Name = format("%s-%s-public-subnet-%s", var.product, var.environment, count.index)
      "kubernetes.io/role/elb" = 1
      Type = "public"
    },
    var.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = local.vpc_id

  tags = merge(
    {
      Name = format("%s-%s-public-rt", var.product, var.environment)
    },
    var.tags
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

##########################
## PRIVATE SUBNETWORKS ###
##########################
resource "aws_subnet" "private" {
  count = local.length_private_subnets

  availability_zone                              = element(var.azs, count.index)
  cidr_block                                     = element(var.private_subnet_cidrs, count.index)
  map_public_ip_on_launch                        = false
  vpc_id                                         = local.vpc_id

  tags = merge(
    {
      Name = format("%s-%s-private-subnet-%s", var.product, var.environment, count.index)
      "kubernetes.io/role/internal-elb" = 1
      Type = "private"
    },
    var.tags
  )
}

resource "aws_route_table" "private" {
  vpc_id = local.vpc_id

  tags = merge(
    {
      Name = format("%s-%s-private-rt", var.product, var.environment)
    },
    var.tags
  )
}

resource "aws_route_table_association" "private" {
  count = local.length_private_subnets

  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

##########################
######## GATEWAYS ########
##########################
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    { Name = "${var.product}-${var.environment}-nat-gw-eip" },
    var.tags
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_internet_gateway" "this" {
  vpc_id = local.vpc_id

  tags = merge(
    { Name = "${var.product}-${var.environment}-igw" },
    var.tags
  )
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id = element(aws_subnet.public[*].id, 0)

  tags = merge(
    { Name = "${var.product}-${var.environment}-nat-gw" },
    var.tags
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id

  timeouts {
    create = "5m"
  }
}
