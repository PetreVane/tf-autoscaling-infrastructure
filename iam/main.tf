
resource "aws_iam_policy" "tf-s3-read-access" {
  name = "S3ReadOnlyPolicy"
  description = "Policy which grants read access to a specific s3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "s3:GetObject",
      Resource = var.expected-bucket-arn,  // "${aws_s3_bucket.bucket.arn}/*",
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_role" "tf-ec2-s3-readonly-role" {
  name = "Ec2S3AccessRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = "ec2.amazonaws.com",
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "tf-s3-policy-attach" {
  policy_arn = aws_iam_policy.tf-s3-read-access.arn
  role       = aws_iam_role.tf-ec2-s3-readonly-role.name
}