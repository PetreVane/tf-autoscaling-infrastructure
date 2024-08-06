provider "aws" {
  region = var.region
}


module "s3" {
  source                            = "./s3"
  bucket_name                       = "tf-bucket-${var.region}"
  jar_file_name                     = "dummy-webapp.jar"
  jar_file_path                     = "./s3/jar/dummy-webapp.jar"
  lambda_zip_name                   = module.lambda.lambda_zip_file_name
  lambda_zip_file_path              = "./s3/lambda/lambda.zip"
  lambda_function_arn               = module.lambda.lambda_function_arn
  lambda_permission_allow_execution = module.lambda.lambda_permission_allow_execution
}

module "sns" {
  source = "./sns"
  notification_email = "test@email.com" // modify this to receive emails
}

module "ssm" {
  source = "./ssm"
}

module "iam" {
  source                 = "./iam"
  expected_bucket_arn    = "${module.s3.s3_bucket_arn}/*"
  expected_sns_topic_arn = module.sns.sns_topic_arn
}

module "vpc" {
  source            = "./vpc"
  vpc_cidr          = "10.0.0.0/16"
  subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  region            = var.region
  availability_zone = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

module "security-group" {
  source = "./security-group"
  vpc_id = module.vpc.vpc_id
}

module "launch-template" {
  source                    = "./launch-template"
  instance_type             = var.instance_type
  aws_security_group_id     = module.security-group.aws_security_group_id
  iam_role_name             = module.iam.iam_role_name
  bucket_name               = module.s3.bucket_id
  jar_file_key              = module.s3.jar_file_key
  iam_instance_profile_name = module.iam.iam_instance_profile_name
}

module "autoscaling-group" {
  source                  = "./autoscaling-group"
  launch-template-version = "$Latest"
  launch-template-id      = module.launch-template.launch-template-id
  subnet-ids              = module.vpc.subnets_ids
  min-size                = "1"
  desired-capacity        = "1"
  max-size                = "3"
  alb-target-group-arn    = module.target-group.target-group-arn
}

module "target-group" {
  source = "./target-group"
  vpc-id = module.vpc.vpc_id
}

module "application-load-balancer" {
  source            = "./load-balancer"
  security_group_id = module.security-group.aws_security_group_id
  subnet_ids        = module.vpc.subnets_ids
  port              = 8080
  target_group_arn  = module.target-group.target-group-arn
}

module "scaling-policy" {
  source                   = "./scaling-policy"
  autoscaling-group-name   = module.autoscaling-group.autoscaling-group-name
  target-group-name        = module.target-group.target-group-name
  target-group-arn-suffix  = module.target-group.target-group-arn-suffix
  load-balancer-type       = module.application-load-balancer.load-balancer-type
  load-balancer-arn        = module.application-load-balancer.load-balancer-arn
  load-balancer-name       = module.application-load-balancer.load-balancer-name
  load-balancer-arn-suffix = module.application-load-balancer.load-balancer-arn-suffix
}

module "lambda" {
  source                  = "./lambda"
  lambda_trigger_role_arn = module.iam.lambda_trigger_role_arn
  ssm_document_name       = module.ssm.ssm_document_name
  asg_name                = module.autoscaling-group.autoscaling-group-name
  sns_topic_arn           = module.sns.sns_topic_arn
  bucket_arn              = module.s3.s3_bucket_arn
  s3_bucket_id            = module.s3.bucket_id
  s3_key                  = module.s3.lambda_file_key
}

module "github" {
  source        = "./github"
  s3_bucket_arn = module.s3.s3_bucket_arn
  s3_bucket_id  = module.s3.bucket_id
  region        = var.region
}