provider "aws" {
  region = var.region
}

module "s3" {
  source        = "./s3"
  bucket_name   = "tf-bucket-07may24"
  jar_file_name = "dummy-webapp.jar"
  jar_file_path = "./s3/jar/dummy-webapp.jar"
}

module "iam" {
  source              = "./iam"
  expected-bucket-arn = "${module.s3.s3_bucket_arn}/*"
}

module "vpc" {
  source = "./vpc"
  vpc_cidr = "10.0.0.0/16"
  subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

module "security-group" {
  source          = "./security-group"
  vpc_id = module.vpc.vpc_id
}

module "launch-template" {
  source                  = "./launch-template"
  instance_type           = "t2.micro"
  aws_security_group_id   = module.security-group.aws_security_group_id
  iam_role_name           = module.iam.iam_role_name
  bucket_name             = module.s3.bucket_name
  jar_file_key            = module.s3.jar_file_key
}

module "autoscaling-group" {
  source                     = "./autoscaling-group"
  aws_subnet_public_subnet-1 = module.vpc.tf-public-subnet-1-id
  aws_subnet_public_subnet-2 = module.vpc.tf-public-subnet-2-id
  launch-template-id         = module.launch-template.launch-template-id
  launch-template-version    = module.launch-template.launch-template-version-latest
  alb-target-group-arn       = "fix me"
}

