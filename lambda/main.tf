
resource "random_id" "generator" {
  byte_length = 4
}

resource "aws_lambda_function" "tf_trigger_lambda" {
  function_name = "tf_trigger_lambda_ssm-${random_id.generator.hex}"
  role          = var.lambda_trigger_role_arn
  handler       = "run_ssm.handler"
  s3_bucket     = var.s3_bucket_id
  s3_key        = var.s3_key
  runtime       = "python3.9"
  memory_size   = 128
  timeout       = 60
  architectures = ["arm64"]

  environment {
    variables = {
      ssm_document_name = var.ssm_document_name
      asg_name   = var.asg_name
      sns_topic_arn     = var.sns_topic_arn
    }
  }
}

resource "aws_lambda_permission" "tf_allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tf_trigger_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket_arn
}