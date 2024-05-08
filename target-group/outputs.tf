
output "target-group-arn" {
  description = "The ARN of the target group."
  value = aws_lb_target_group.tf-target-group.arn
}

output "target-group-name" {
  description = "The name of the target group."
  value = aws_lb_target_group.tf-target-group.name
}

output "target-group-id" {
  description = "The id of the target group"
  value = aws_lb_target_group.tf-target-group.id
}