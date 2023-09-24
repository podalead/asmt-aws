resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    { Name = "${var.tag_product}-${var.tag_environment}-nat-gw-eip" },
    local.tags
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_internet_gateway" "this" {
  vpc_id = local.vpc_id

  tags = merge(
    { Name = "${var.tag_product}-${var.tag_environment}-igw" },
    local.tags
  )
}

resource "aws_nat_gateway" "this" {
  subnet_id = element(aws_subnet.public[*].id, 0)

  tags = merge(
    { Name = "${var.tag_product}-${var.tag_environment}-nat-gw" },
    local.tags
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = element(aws_route_table.private[0].id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[0].id, count.index)

  timeouts {
    create = "5m"
  }
}
