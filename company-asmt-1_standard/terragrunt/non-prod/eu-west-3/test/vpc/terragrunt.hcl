terraform {
  source = "${include.envcommon.locals.base_source_url}?version=3.14.2"
}

include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path   = "${dirname(find_in_parent_folders())}/_envcommon/vpc.hcl"
  expose = true
}