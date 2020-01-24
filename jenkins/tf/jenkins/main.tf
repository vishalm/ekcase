# Security contains all the resources like bastion, master and slave.

resource "aws_security_group" "jmaster" {
  name        = "master"
  description = "Only inbound TLS Allowed"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    security_groups = [
      aws_security_group.bastionhostsg.id
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "jslave" {
  name        = "slave"
  description = "SSH is allowed to slave"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    security_groups = [
      aws_security_group.bastionhostsg.id, aws_security_group.jmaster.id
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "master-efs-storage" {
  name        = "master-efs-storage"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    security_groups = [
      aws_security_group.jmaster.id
    ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bastionhostsg" {
  name        = "bastion host sg"
  description = "bastion host security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


# Jenkins master launch configaration
provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_launch_configuration" "jmaster" {
  image_id        = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.jmaster.id]
  depends_on      = [aws_security_group.jmaster]
  user_data       = data.template_file.master_user_data.rendered
  root_block_device {
    volume_size = 20
  }
  ebs_block_device {
    volume_size = 100
    device_name = "/dev/xvdf"
  }
}

resource "aws_efs_file_system" "jmaster" {
  creation_token = "JenkinsMaster"
  tags           = var.resources_tags
}

data "template_file" "master_user_data" {
  template = "${file("${path.module}/scripts/startup-master.sh.tpl")}"

  vars = {
    efs_dns_name = aws_efs_file_system.jmaster.dns_name
  }
}

resource "aws_efs_mount_target" "jmaster" {
  file_system_id  = aws_efs_file_system.jmaster.id
  subnet_id       = element(var.private_subnet_ids, 0)
  security_groups = [aws_security_group.master-efs-storage.id]
}

# Load balance will provide high availiablity 

resource "aws_autoscaling_group" "jmaster" {
  name                 = "jmaster"
  max_size             = 4
  min_size             = 1
  desired_capacity     = 1
  force_delete         = true
  launch_configuration = aws_launch_configuration.jmaster.name
  health_check_type    = "EC2"
  target_group_arns    = [aws_lb_target_group.jmaster.arn]
  termination_policies = ["OldestLaunchConfiguration"]
  vpc_zone_identifier  = var.private_subnet_ids
  depends_on           = [aws_launch_configuration.jmaster]
  lifecycle {
    create_before_destroy = true
  }
  dynamic "tag" {
    for_each = var.resources_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

# ASP to scale up and scale down master based on CPU utilization. Jenkins scales up on 80% cpu utilization
resource "aws_autoscaling_policy" "agents-scale-up-master" {
  name                   = "agents-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.jmaster.name
}

resource "aws_autoscaling_policy" "agents-scale-down-master" {
  name                   = "agents-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.jmaster.name
}

# Cloud watch notification to scale up or down jenkins when load of 80% utilization & to send mail notification

resource "aws_cloudwatch_metric_alarm" "memory-high" {
  alarm_name          = "mem-util-high-agents"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors ec2 memory for high utilization on agent hosts"
  alarm_actions = [
    aws_autoscaling_policy.agents-scale-up-master.arn,
    "arn:aws:sns:ap-southeast-1:201574045515:jenkins-ek-alert"
  ]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.jmaster.name
  }
}

resource "aws_cloudwatch_metric_alarm" "memory-low" {
  alarm_name          = "mem-util-low-agents"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "System/Linux"
  period              = "300"
  statistic           = "Average"
  threshold           = "40"
  alarm_description   = "This metric monitors ec2 memory for low utilization on agent hosts"
  alarm_actions = [
    aws_autoscaling_policy.agents-scale-down-master.arn,
    "arn:aws:sns:ap-southeast-1:201574045515:jenkins-ek-alert"
  ]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.jmaster.name
  }
}

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
