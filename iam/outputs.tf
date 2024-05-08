
output "iam_role_name" {
  value = aws_iam_role.tf-ec2-s3-readonly-role.name
}

output "iam_role_arn" {
  value = aws_iam_role.tf-ec2-s3-readonly-role.arn
}

output "iam_role_id" {
  value = aws_iam_role.tf-ec2-s3-readonly-role.id
}

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.tf-ec2-instance-profile.name
}


