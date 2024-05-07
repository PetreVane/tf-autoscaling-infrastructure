
output "launch-template-id" {
  value = aws_launch_template.tf-launch_template_1.id
}
output "launch-template-arn" {
  value = aws_launch_template.tf-launch_template_1.arn
}

output "launch-template-name" {
  value = aws_launch_template.tf-launch_template_1.name
}

output "launch-template-name-prefix" {
  value = aws_launch_template.tf-launch_template_1.name_prefix
}

output "launch-template-version-latest" {
  value = aws_launch_template.tf-launch_template_1.latest_version
}