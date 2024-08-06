
/*
This block defines local variables:

- role_name is set to a string that includes the region, making it unique across regions.
- oidc_provider_arn is a complex conditional that decides which OIDC provider ARN to use based on whether
  we're creating a new one or using an existing one.

 */
locals {
  role_name = "tf_github_actions_role-${var.region}"
  oidc_provider_arn = var.create_oidc_provider ? (
    length(aws_iam_openid_connect_provider.github_actions) > 0 ?
    aws_iam_openid_connect_provider.github_actions[0].arn :
    null
  ) : (
    length(data.aws_iam_openid_connect_provider.existing_github_provider) > 0 ?
    data.aws_iam_openid_connect_provider.existing_github_provider[0].arn :
    null
  )
}

/*
These blocks fetch existing data from AWS:

- aws_caller_identity gets information about the current AWS account.
- aws_iam_openid_connect_provider looks for an existing OIDC provider, but only if we're not creating a new one.
- tls_certificate fetches the TLS certificate for GitHub Actions.
 */

data "aws_caller_identity" "current_account_id" {}

data "aws_iam_openid_connect_provider" "existing_github_provider" {
  count = var.create_oidc_provider ? 0 : 1
  url = "https://token.actions.githubusercontent.com"
}

data "tls_certificate" "github_actions" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

/*
This creates a new OIDC provider for GitHub Actions, but only if var.create_oidc_provider is true.
It uses the certificate thumbprint fetched earlier.
 */
resource "aws_iam_openid_connect_provider" "github_actions" {
  count = var.create_oidc_provider ? 1 : 0
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_actions.certificates[0].sha1_fingerprint]
  url             = "https://token.actions.githubusercontent.com"
  tags = merge(
    var.tags, { Name = "Github Actions OIDC provider"}
  )
}

/*
This creates an IAM role that can be assumed by GitHub Actions.
The assume role policy allows the role to be assumed using OpenID Connect from GitHub.
 */
resource "aws_iam_role" "github_actions_role" {
  name = local.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Action": [
          "sts:AssumeRoleWithWebIdentity"
        ],
        Effect = "Allow",
        Principal = {
          Federated = local.oidc_provider_arn != null ? local.oidc_provider_arn : "arn:aws:iam::${data.aws_caller_identity.current_account_id.account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
          },
          StringLike = {
            "token.actions.githubusercontent.com:sub": "repo:${var.github_repo}:*"
          }
        }
      }
    ]
  })

  tags = merge(
    var.tags, { Name = "Github Actions role"}
  )
}

# This creates an IAM policy that allows listing, uploading, and deleting objects in a specific S3 bucket.
resource "aws_iam_policy" "github_upload_to_s3" {
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${var.s3_bucket_arn}",
          "${var.s3_bucket_arn}/application/jar/${var.jar_file_name}"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter"
        ]
        Resource = "arn:aws:ssm:*:*:parameter/github-actions/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_role_policy_attachment" {
  policy_arn = aws_iam_policy.github_upload_to_s3.arn
  role       = aws_iam_role.github_actions_role.name
}

/*
This creates a parameter in AWS Systems Manager Parameter Store to store the ARN of the GitHub Actions role.
This makes it easy to retrieve the role ARN in GitHub Actions workflows.
 */
resource "aws_ssm_parameter" "github_actions_role_arn" {
  name  = "/github-actions/role-arn"
  type  = "String"
  value = aws_iam_role.github_actions_role.arn
  tags = merge(
    var.tags, { Name = "Github Actions Role ARN"}
  )
}

resource "aws_ssm_parameter" "github_actions_bucket_id" {
  name = "/github-actions/s3-bucket-name"
  type = "String"
  value = var.s3_bucket_id
  tags = merge(
    var.tags, { Name = "Github Action Bucket Id" }
  )
}

resource "aws_ssm_parameter" "github_actions_region" {
  name = "/github-actions/region"
  type = "String"
  value = var.region
  tags = merge(
    var.tags, {Name = "AWS region"}
  )
}
