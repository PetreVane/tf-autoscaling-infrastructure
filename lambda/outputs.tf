
output "lambda_zip_file_name" {
  value = var.lambda_zip_file_name
}

output "lambda_function_name" {
  value = aws_lambda_function.tf_lambda_executor.filename
}

output "lambda_function_arn" {
  value = aws_lambda_function.tf_lambda_executor.arn
}

output "lambda_permission_allow_execution" {
  value = aws_lambda_permission.tf_allow_s3.id
}