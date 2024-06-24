
variable "lambda_zip_file_name" {
  type = string
  description = "The name of the zipfile containing the pythin code"
  default = "lambda.zip"
}


variable "lambda_trigger_role_arn" {
  type = string
  description = "The role arn of the lambda function which triggers the ssm document"
}

variable "ssm_document_name" {
  type = string
  description = "The SSM Document name"
}

variable "asg_name" {
  type = string
  description = "The name of asg on which instances the ssm doc will be executed"
}

variable "sns_topic_arn" {
  type = string
  description = "The arn of the topic on which lambda execution failures will be published"
}

variable "bucket_arn" {
  type = string
  description = "The arn of the bucket on which the jar files are uploaded, which triggers the lamda for ssm doc execution"
}

variable "s3_bucket_id" {
  type = string
  description = "The bucket id where the lambda code is stored"
}

variable "s3_key" {
  type = string
  description = "The object key name for lambda zip file"
}