output "s3_bucket_id" {
  value = aws_s3_bucket.tf-bucket-07may24.id
  description = "The ID of the S3 bucket."
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.tf-bucket-07may24.arn
  description = "The ARN of the S3 bucket."
}

output "s3_object_key" {
  value = aws_s3_object.object.key
  description = "The key of the uploaded object within the S3 bucket."
}
