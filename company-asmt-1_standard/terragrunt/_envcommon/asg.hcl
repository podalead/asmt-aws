locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env = local.environment_vars.locals.environment
  base_source_url = "tfr:///terraform-aws-modules/autoscaling/aws"
}

inputs = {
  # Autoscaling group
  name = format("headway-inst-%s", local.env)

  min_size                  = 0
  max_size                  = 2
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"

  # Launch template
  launch_template_name        = format("headway-asg-template-%s", local.env)
  update_default_version      = true

  ebs_optimized     = true
  enable_monitoring = true

  # IAM role & instance profile
  create_iam_instance_profile = true
  iam_role_name               = format("headway-asg-inst-profile-%s", local.env)
  iam_role_path               = "/"

  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = {
    Name = format("headway-inst-%s", local.env)
    Environment = "${local.env}"
    Created_by = "Mykhail Poda"
  }
}