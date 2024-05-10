
resource "aws_autoscaling_policy" "tf-target-tracking-policy" {
  name                     = "tf-target-tracking-policy"
  autoscaling_group_name   = var.autoscaling-group-name
  policy_type = "TargetTrackingScaling"
  estimated_instance_warmup = 300

  target_tracking_configuration {
    target_value             = 20 # 20 requests/ instance for a given period of time
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label = "${var.load-balancer-arn-suffix}/${var.target-group-arn-suffix}"
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_utilisation" {
  alarm_name          = "high_cpu_utilisation"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 120
  statistic           = "Average"
  threshold           = 75
  alarm_actions       = [aws_autoscaling_policy.tf-target-tracking-policy.arn]

  dimensions = {
    AutoScalingGroupName = var.autoscaling-group-name
  }
}

