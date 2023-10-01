resource "aws_instance" "ec2_instance" {
  count = lookup(var.instance_conf, "count", 0) * length(var.aws_availability_zone)

  ami = var.ami_id
  subnet_id = element(var.subnet_id, count.index)
  availability_zone = element(var.aws_availability_zone, count.index)
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name = var.aws_ssh_pub_key_id
  instance_type = lookup(var.instance_conf, "type", "t3a.small")

  associate_public_ip_address = var.associate_public_ip_address

  tags = merge(var.tags,
    map("Name", format("%s-%s", var.name, count.index)),
    map("Zone", element(var.aws_availability_zone, count.index))
  )
}