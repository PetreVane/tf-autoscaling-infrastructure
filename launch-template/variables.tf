

variable "instance_type" {
  type = string
  description = "The type of the ec2 instance used in this template"
}

variable "aws_security_group_id" {
  type = string
  description = "The security group ID to associate with the EC2 instances"
}

variable "iam_role_name" {
  description = "The Name of the IAM role that the EC2 instances should assume"
  type        = string
}

variable "bucket_name" {
  type = string
  description = "The bucket name where the jar artifact is stored"
}

variable "jar_file_key" {
  type = string
  description = "The jar artifact object key"
}