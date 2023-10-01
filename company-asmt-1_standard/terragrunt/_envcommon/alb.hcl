locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env = local.environment_vars.locals.environment
  base_source_url = "tfr:///terraform-aws-modules/alb/aws"
}

inputs = {
  name = format("headway-alb-%s", local.env)

  load_balancer_type = "application"

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name_prefix      = "tar-"
      backend_protocol = "HTTP"
      backend_port     = 8080
      target_type      = "instance"
      health_check     = {
        enabled             = true
        interval            = 25
        path                = "/test"
        port                = 8080
        healthy_threshold   = 5
        unhealthy_threshold = 5
        timeout             = 20
        protocol            = "HTTP"
        matcher             = 200
      }
    }
  ]

  tags = {
    Name = format("headway-listener-%s", local.env)
    Environment = "${local.env}"
    Created_by = "Mykhail Poda"
  }
}