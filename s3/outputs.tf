output "bucket_id" {
  value = aws_s3_bucket.tf_bucket.id
  description = "The ID of the S3 bucket."
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.tf_bucket.arn
  description = "The ARN of the S3 bucket."
}

output "jar_file_key" {
  value = aws_s3_object.object.key
  description = "The key of the uploaded object within the S3 bucket."
}

output "lambda_file_key" {
  value = aws_s3_object.lambda_zip.key
  description = "The key object of lambda zip file"
}
