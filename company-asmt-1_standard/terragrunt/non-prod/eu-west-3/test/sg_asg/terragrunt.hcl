terraform {
  source = "${include.envcommon.locals.base_source_url}?version=4.9.0"
}

include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/sg_asg.hcl"
  expose = true
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "sg_alb" {
  config_path = "../sg_alb"
}

inputs = {
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-8080-tcp"
      source_security_group_id = dependency.sg_alb.outputs.security_group_id
    },
  ]
}