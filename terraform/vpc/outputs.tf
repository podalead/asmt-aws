output "vpc_id" {
  value = aws_vpc.asmt_vpc.id
}

output "vpc_cidr" {
  value = aws_vpc.asmt_vpc.cidr_block
}

output "vpc_publict_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "vpc_private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "vpc_private_subnet_cidrs" {
  value = aws_subnet.private[*].cidr_block
}

output "vpc_public_subnet_cidrs" {
  value = aws_subnet.public[*].cidr_block
}
