resource "aws_security_group" "ci_access" {
  name = "sg_ci"
  vpc_id = module.vpc.vpc_id

  ingress {
    cidr_blocks = local.network_cidr_ci_block
    from_port = 0
    to_port = 65345
    protocol = "tcp"
  }
}

resource "aws_security_group" "bastion_ssh" {
  name = "sg_bastion"
  vpc_id = module.vpc.vpc_id

  ingress {
    cidr_blocks = local.network_cidr_bastion_block
    to_port = 22
    from_port = 22
    protocol = "tcp"
  }
}

resource "aws_security_group" "egress" {
  name = "sg_egress"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "tcp"
    to_port = 65345
  }
}

resource "aws_security_group" "rds" {
  name = "sg_rds"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "instance" {
  name = "sg_instance"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "proxy" {
  name = "sg_proxy"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "rds_input" {
  security_group_id = aws_security_group.rds.id
  cidr_blocks = concat(var.network_cidr_private_block, local.network_cidr_bastion_block, local.network_cidr_ci_block)
  type = "ingress"
  protocol = "tcp"
  from_port = 5432
  to_port = 5432
}

resource "aws_security_group_rule" "instance_input" {
  security_group_id = aws_security_group.instance.id
  cidr_blocks = var.network_cidr_public_block
  type = "ingress"
  protocol = "tcp"
  from_port = 8080
  to_port = 8080
}

resource "aws_security_group_rule" "proxy_https_input" {
  security_group_id = aws_security_group.proxy.id
  cidr_blocks = [ "0.0.0.0/0" ]
  type = "ingress"
  protocol = "tcp"
  from_port = 443
  to_port = 443
}

resource "aws_security_group_rule" "proxy_http_input" {
  security_group_id = aws_security_group.proxy.id
  cidr_blocks = [ "0.0.0.0/0" ]
  type = "ingress"
  protocol = "tcp"
  from_port = 80
  to_port = 80
}