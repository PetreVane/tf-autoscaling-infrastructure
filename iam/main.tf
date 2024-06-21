resource "random_id" "generator" {
  byte_length = 4
}

resource "aws_iam_policy" "tf-s3-read-access" {
  name = "S3ReadOnlyPolicy-${random_id.generator.hex}"
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
  name = "Ec2S3AccessRole-${random_id.generator.hex}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "tf-s3-policy-attach" {
  policy_arn = aws_iam_policy.tf-s3-read-access.arn
  role       = aws_iam_role.tf-ec2-s3-readonly-role.name
}

resource "aws_iam_instance_profile" "tf-ec2-instance-profile" {
  name = "EC2InstanceProfile-${random_id.generator.hex}"
  role = aws_iam_role.tf-ec2-s3-readonly-role.name
}