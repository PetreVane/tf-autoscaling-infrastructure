
output "iam_role_name" {
  value = aws_iam_role.tf_ec2_s3_readonly_role.name
}

output "iam_role_arn" {
  value = aws_iam_role.tf_ec2_s3_readonly_role.arn
}

output "iam_role_id" {
  value = aws_iam_role.tf_ec2_s3_readonly_role.id
}

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.tf_ec2_instance_profile.name
}

output "lambda_trigger_role_arn" {
  description = "The role of the lambda function which triggers the ssm document"
  value = aws_iam_role.tf_lambda_trigger_role.arn
}

