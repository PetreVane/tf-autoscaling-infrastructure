
resource "random_id" "bucket_id" {
  byte_length = 4
}


resource "aws_s3_bucket" "tf_bucket" {
  bucket = "${var.bucket_name}-${random_id.bucket_id.hex}"
  tags = {
    Name        = "tf-JavaAppBucket"
    Environment = "Development"
  }
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.tf_bucket.id
  key    = "application/jar/${var.jar_file_name}"
  source = var.jar_file_path // Local path to the jar file
  etag   = filemd5(var.jar_file_path)
}

resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.tf_bucket.id
  key    = "application/lambda/${var.lambda_zip_name}"
  source = var.lambda_zip_file_path  //"${path.module}/lambda/lambda.zip"
}

resource "aws_s3_bucket_notification" "tf_bucket_notification" {
  bucket = aws_s3_bucket.tf_bucket.id

  lambda_function {
    lambda_function_arn = var.lambda_function_arn
    events = ["s3:ObjectCreated:*"]
    filter_prefix = "application/jar/"
    filter_suffix = ".jar"
  }

  depends_on = [var.lambda_permission_allow_execution]
}