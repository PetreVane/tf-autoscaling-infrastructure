
resource "aws_autoscaling_group" "tf-autoscaling-group" {
  launch_template {
    id = var.launch-template-id
    version = var.launch-template-version
  }

  max_size = var.max-size
  min_size = var.min-size
  desired_capacity = var.desired-capacity
  vpc_zone_identifier = var.subnet-ids
#   target_group_arns = [var.alb-target-group-arn]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "tf-asg-instance"
    propagate_at_launch = true
  }

}
