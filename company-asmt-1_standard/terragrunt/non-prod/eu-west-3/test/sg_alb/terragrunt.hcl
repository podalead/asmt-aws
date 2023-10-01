terraform {
  source = "${include.envcommon.locals.base_source_url}?version=4.9.0"
}

include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/sg_alb.hcl"
  expose = true
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  vpc_id      = dependency.vpc.outputs.vpc_id
}