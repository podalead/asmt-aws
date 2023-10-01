resource "aws_subnet" "bastion" {
  cidr_block = var.network_cidr_bastion_block
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "my-bastion-subnet"
    Description = "Bastion secured network"
  }
}

resource "aws_eip" "bastion" {}

resource "aws_eip_association" "bastion" {
  instance_id = module.bastion.instance_id
  allocation_id = aws_eip.bastion.id
  allow_reassociation = true
}

resource "aws_route_table" "bastion_route_table" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "bastion-rt"
  }
}

resource "aws_route_table_association" "bastion_rt_association" {
  route_table_id = aws_route_table.bastion_route_table.id
  subnet_id = aws_subnet.bastion.id
}

resource "aws_route" "internet_bastion_access" {
  route_table_id = aws_route_table.bastion_route_table.id
  gateway_id = module.vpc.igw_id
  destination_cidr_block = "0.0.0.0/0"
}

module "bastion" {
  source  = "modules/bastion"

  name = var.bastion_name
  namespace = var.bastion_namespace
  instance_type = "t3a.small"
  security_groups = [ aws_security_group.egress.id ]
  ssh_user = var.bastion_ssh_user
  stage = var.bastion_stage
  subnets = list(aws_subnet.bastion.id)
  vpc_id = module.vpc.vpc_id
  key_name = aws_key_pair.key.key_name
  allowed_cidr_blocks = var.allowed_ip
  ami = data.aws_ami.base_ami.id
  tags = {
    Name = "my-bastion-server"
    Role = "bastion"
  }
}

resource "aws_route53_record" "bastion" {
  count   = data.aws_route53_zone.main.zone_id != "" ? 1 : 0
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.bastion_namespace
  type    = "A"
  ttl     = 60
  records = [ aws_eip.bastion.public_ip ]

  lifecycle {
    create_before_destroy = true
  }
}


