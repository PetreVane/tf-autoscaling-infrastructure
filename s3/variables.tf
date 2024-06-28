variable "bucket_name" {
  description = "The name of the S3 bucket to create."
  type        = string
}

variable "jar_file_name" {
  description = "The name of the jar file to upload."
  type        = string
}

variable "jar_file_path" {
  description = "The local path for the jar file to upload."
  type        = string
}

variable "lambda_zip_name" {
  description = "The name of the lambda zip file"
  type = string
}

variable "lambda_zip_file_path" {
  description = "The local path of the lambda zip file"
  type = string
}

variable "lambda_function_arn" {
  type = string
  description = "The arn of the lambda function which executed the ssm document"
}

variable "lambda_permission_allow_execution" {
  type = string
  description = "The permission which allows lambda invocations from s3 bucket"
}