
output "launch-template-id" {
  value = aws_launch_template.tf-launch_template.id
}

output "launch-template-version-latest" {
  value = aws_launch_template.tf-launch_template.latest_version
}