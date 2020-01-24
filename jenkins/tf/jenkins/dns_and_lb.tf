# 2 Load balances are exposed one on http and another on https on jenkins-ek.com

resource "aws_lb" "jmaster" {
  name                       = "jmaster"
  internal                   = false
  load_balancer_type         = "network"
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = false
  tags                       = var.resources_tags
}

resource "aws_lb_listener" "jmaster" {
  load_balancer_arn = aws_lb.jmaster.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jmaster.arn
  }
}

resource "aws_lb_listener" "jmaster_https" {
  load_balancer_arn = aws_lb.jmaster.arn
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:ap-southeast-1:201574045515:certificate/559ec8fb-300f-4e1b-8378-735fddacdcdd"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jmaster.arn
  }
}  

resource "aws_lb_target_group" "jmaster" {
  name_prefix = "jm"
  port        = 8080
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "jmaster" {
  zone_id = "ZJG2TV14UHIGQ"
  name    = "my.jenkins-ek.com"
  type    = "A"

  alias {
    name                   = aws_lb.jmaster.dns_name
    zone_id                = aws_lb.jmaster.zone_id
    evaluate_target_health = true
  }
}
