provider "aws" {
  region = var.region
}

locals {
  prefix = var.profile == "prod" ? "" : "${var.prefix}-"
  profile_dir = format("%s/profiles/%s", var.pipe_root, var.profile)
  ssh_access_key_path = format("%s/ssh/%s", local.profile_dir, var.key_name)
  network_cidr_bastion_block = [var.network_cidr_bastion_block]
  network_cidr_ci_block = [var.network_cidr_ci_block]
}

terraform {
  backend "local" {}
}

data "aws_ami" "base_ami" {
  owners = [ "099720109477" ]

  filter {
    name = "name"
    values = ["ubuntu/images/*ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }

  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }

  most_recent = true
}
