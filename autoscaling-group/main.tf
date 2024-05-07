
resource "aws_autoscaling_group" "tf-asg-1" {
  max_size = 2
  min_size = 2
  desired_capacity = 2
  vpc_zone_identifier = [var.aws_subnet_public_subnet-1, var.aws_subnet_public_subnet-2]
  target_group_arns = [var.alb-target-group-arn]

  launch_template {
    id = var.launch-template-id
  }
}
