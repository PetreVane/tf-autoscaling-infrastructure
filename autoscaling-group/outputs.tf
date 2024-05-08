
output "autoscaling-group-id" {
  value = aws_autoscaling_group.tf-autoscaling-group.id
  description = "The ASG id"
}

output "autoscaling-group-name" {
  value = aws_autoscaling_group.tf-autoscaling-group.name
  description = "The name of the ASG"
}