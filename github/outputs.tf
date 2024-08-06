
output "github_actions_role_arn" {
  description = "ARN of the IAM role for GitHub Actions"
  value       = aws_iam_role.github_actions_role.arn
}

output "github_actions_role_name" {
  description = "Name of the IAM role for GitHub Actions"
  value       = aws_iam_role.github_actions_role.name
}

output "ssm_parameter_name" {
  description = "Name of the SSM parameter storing the GitHub Actions role ARN"
  value       = aws_ssm_parameter.github_actions_role_arn.name
}

output "oidc_provider_arn" {
  description = "ARN of the OIDC provider for GitHub Actions"
  value       = local.oidc_provider_arn
}
