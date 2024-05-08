
output "autoscaling-group-id" {
  value = aws_autoscaling_group.tf-autoscaling-group.id
  description = "The ASG id"
}