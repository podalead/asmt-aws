terraform {
  source = "${include.envcommon.locals.base_source_url}?version=7.0.0"
}

include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/alb.hcl"
  expose = true
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "sg_alb" {
  config_path = "../sg_alb"
}

inputs = {
  vpc_id             = dependency.vpc.outputs.vpc_id
  subnets            = dependency.vpc.outputs.public_subnets
  security_groups    = [dependency.sg_alb.outputs.security_group_id]
}