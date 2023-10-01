module "elb" {
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 2.0"

  name = "elb"

  subnets         = module.vpc.public_subnets
  security_groups = [ aws_security_group.proxy.id, aws_security_group.egress.id ]
  internal        = false

  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    },
    {
      instance_port     = "80"
      instance_protocol = "http"
      lb_port           = "443"
      lb_protocol       = "https"
      ssl_certificate_id = data.aws_acm_certificate.cert.arn
    },
  ]

  health_check = {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
  }

  // ELB attachments
  number_of_instances = length(module.proxy_instance.instance_ids)
  instances           = module.proxy_instance.instance_ids

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

data "aws_acm_certificate" "cert" {
  domain = var.dns_name
  statuses = ["ISSUED"]
  most_recent = true
}