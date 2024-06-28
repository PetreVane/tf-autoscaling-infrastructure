resource "random_id" "generator" {
  byte_length = 4
}

resource "aws_iam_policy" "tf_s3_read_access" {
  name = "S3ReadOnlyPolicy-${random_id.generator.hex}"
  description = "Policy which grants read access to a specific s3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "s3:List*",
        "s3:ListBucket",
        "s3:GetObject"
      ],
      Resource = var.expected_bucket_arn,  // "${aws_s3_bucket.bucket.arn}/*",
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_policy" "tf_ssm_access" {
  name = "SsmAccess-${random_id.generator.hex}"
  description = "Allows execution of SSM documents and more"
  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:UpdateInstanceInformation",
        "ssm:ListInstanceAssociations",
        "ssm:DescribeInstanceProperties",
        "ssm:DescribeInstanceInformation",
        "ssm:CreateActivation",
        "ssm:PutInventory",
        "ec2messages:*",
        "ssmmessages:*",
        "s3:GetObject"
      ],
      "Resource": "*"
    }
  ]
  })
}

resource "aws_iam_role" "tf_ec2_execution_role" {
  name = "tfEc2ExecutionRole-${random_id.generator.hex}"
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

resource "aws_iam_role_policy_attachment" "tf_s3_policy_attach" {
  policy_arn = aws_iam_policy.tf_s3_read_access.arn
  role       = aws_iam_role.tf_ec2_execution_role.name
}

resource "aws_iam_role_policy_attachment" "tf_ssm_policy_attach" {
  policy_arn = aws_iam_policy.tf_ssm_access.arn
  role       = aws_iam_role.tf_ec2_execution_role.name
}

resource "aws_iam_instance_profile" "tf_ec2_instance_profile" {
  name = "EC2InstanceProfile-${random_id.generator.hex}"
  role = aws_iam_role.tf_ec2_execution_role.name
}

// iam role for lambda function
resource "aws_iam_role" "tf_lambda_executor_role" {
  name = "tf_lambda_executor_role-${random_id.generator.hex}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "tf_lambda_executor_permission_policy" {
  name = "tf_lambda_executor_permission_policy-${random_id.generator.hex}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action = [
          "sns:Publish"
        ],
        Effect = "Allow",
        Resource = var.expected_sns_topic_arn
      },
      {
        Action = [
          "autoscaling:DescribeAutoScalingInstances",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ssm:SendCommand",
          "ssm:GetCommandInvocation"
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tf_lambda_executor_policy_association" {
  policy_arn = aws_iam_policy.tf_lambda_executor_permission_policy.arn
  role = aws_iam_role.tf_lambda_executor_role.name
}