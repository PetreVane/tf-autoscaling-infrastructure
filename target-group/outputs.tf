
output "target-group-arn" {
  description = "The ARN of the target group."
  value = aws_lb_target_group.tf-target-group.arn
}

output "target-group-name" {
  description = "The name of the target group."
  value = aws_lb_target_group.tf-target-group.name
}