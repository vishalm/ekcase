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
