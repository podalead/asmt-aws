resource "aws_subnet" "ci" {
  cidr_block = var.network_cidr_ci_block
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "my-ci-subnet"
    Description = "CI/CD secured network"
  }
}

resource "aws_eip" "ci" {}

resource "aws_eip_association" "ci" {
  instance_id = module.ci.instance_id
  allocation_id = aws_eip.ci.id
  allow_reassociation = true
}

resource "aws_route_table" "ci_route_table" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "ci-rt"
  }
}

resource "aws_route_table_association" "ci_rt_association" {
  route_table_id = aws_route_table.ci_route_table.id
  subnet_id = aws_subnet.ci.id
}

resource "aws_route" "internet_ci_access" {
  route_table_id = aws_route_table.ci_route_table.id
  gateway_id = module.vpc.igw_id
  destination_cidr_block = "0.0.0.0/0"
}

module "ci" {
  source  = "modules/bastion"

  name = "ci"
  namespace = "ci"
  instance_type = "t3a.small"
  security_groups = [ aws_security_group.egress.id ]
  ssh_user = var.ci_ssh_user
  stage = var.ci_stage
  subnets = list(aws_subnet.ci.id)
  vpc_id = module.vpc.vpc_id
  key_name = aws_key_pair.key.key_name
  allowed_cidr_blocks = var.allowed_ip
  ami = data.aws_ami.base_ami.id
  tags = {
    Name = "my-ci-server"
    Role = "ci"
  }
}

resource "aws_route53_record" "ci" {
  count   = data.aws_route53_zone.main.zone_id != "" ? 1 : 0
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "ci"
  type    = "A"
  ttl     = 60
  records = [ aws_eip.ci.public_ip ]

  lifecycle {
    create_before_destroy = true
  }
}


