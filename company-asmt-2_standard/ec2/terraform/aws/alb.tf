///*
//module "alb" {
//  name                          = "alb"
//  source                        = "terraform-aws-modules/alb/aws"
//  load_balancer_type            = "application"
//  log_location_prefix           = "my-alb-logs"
//  tags                          = map("Environment", var.profile)
//  vpc_id                        = module.vpc.vpc_id
//  subnets                       = module.vpc.public_subnets
//  security_groups               = [ aws_security_group.egress.id, aws_security_group.proxy.id ]
//
//  http_tcp_listeners            = list(map("port", "80",  "protocol", "HTTP"))
//  https_listeners               = list(map("port", "443", "protocol", "HTTPS", "certificate_arn",data.aws_acm_certificate.cert.arn))
//
//  target_groups                 = [
//    {
//      name             = "https",
//      backend_protocol = "HTTPS",
//      backend_port     = "443",
//      target_type      = "instance"
//      health_check     = {
//        enabled             = true
//        interval            = "10"
//        path                = "/"
//        port                = "443"
//        healthy_threshold   = "3"
//        unhealthy_threshold = "9"
//        timeout             = "3"
//        protocol            = "HTTPS"
//      }
//    }
//  ]
//}
//
//resource "aws_alb_target_group_attachment" "asd" {
//  count = length(module.proxy_instance.instance_ids)
//  target_group_arn = module.alb.target_group_arns.0
//  target_id = module.proxy_instance.instance_ids[count.index]
//}
//

