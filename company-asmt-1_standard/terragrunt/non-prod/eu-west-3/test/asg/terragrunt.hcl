terraform {
  source = "${include.envcommon.locals.base_source_url}?version=6.5.1"
}

include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/asg.hcl"
  expose = true
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "alb" {
  config_path = "../alb"
}

dependency "sg_asg" {
  config_path = "../sg_asg"
}

inputs = {
  vpc_zone_identifier       = dependency.vpc.outputs.private_subnets

  user_data         = base64encode("#!/bin/bash\nsudo docker run -tid -p 8080:8080 chentex/go-rest-api:latest")
  image_id          = "ami-023ac0373d7e1b0b3"
  instance_type     = "t3.micro"

  security_groups   = [dependency.sg_asg.outputs.security_group_id]
  target_group_arns = dependency.alb.outputs.target_group_arns

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/sda1"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 20
        volume_type           = "gp2"
      }
    }
  ]
}