
data "archive_file" "run_ssm_document" {
  type        = "zip"
  source_file = "${path.module}/run_ssm.py"
  output_path = "${path.root}/s3/lambda/lambda.zip"
}