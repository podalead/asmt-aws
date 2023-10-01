resource "aws_key_pair" "key" {
  key_name_prefix = var.prefix
  public_key = file(local.ssh_access_key_path)
}

module "application_instance" {
  source = "modules/ec2"
  aws_availability_zone = var.availability_zones

  name = "my-application-server"
  ami_id = data.aws_ami.base_ami.id
  aws_ssh_pub_key_id = aws_key_pair.key.id
  instance_conf = var.app_instance_conf
  subnet_id = module.vpc.private_subnets
  associate_public_ip_address = false
  vpc_security_group_ids = [
    aws_security_group.egress.id,
    aws_security_group.instance.id,
    aws_security_group.bastion_ssh.id,
    aws_security_group.ci_access.id]

  tags = {
    Role = "app"
  }
}

module "proxy_instance" {
  source = "modules/ec2"
  aws_availability_zone = var.availability_zones

  name = "my-proxy-server"
  ami_id = data.aws_ami.base_ami.id
  aws_ssh_pub_key_id = aws_key_pair.key.id
  instance_conf = var.proxy_instance_conf
  subnet_id = module.vpc.public_subnets
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.egress.id,
    aws_security_group.proxy.id,
    aws_security_group.bastion_ssh.id,
    aws_security_group.ci_access.id]

  tags = {
    Role = "proxy"
  }
}
