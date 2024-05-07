
variable "aws_subnet_public_subnet-1" {
  type = string
  description = "The subnet ID in which the ec2 will be deployed by ASG"
}

variable "aws_subnet_public_subnet-2" {
  type = string
  description = "The subnet ID in which the ec2 will be deployed by ASG"
}

variable "launch-template-id" {
  type = string
  description = "The ID of the launch template used by the ASG"
}

variable "launch-template-version" {
  type = string
  description = "The version of the launch template used by ASG"
}

variable "nlb-target-group-arn" {
  type = string
  description = "The arn of the target group"
}