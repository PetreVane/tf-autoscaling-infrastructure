
variable "image_id" {
  type = string
  description = "The AWS Image identifier"
}

variable "instance_type" {
  type = string
  description = "The type of the ec2 instance used in this template"
}


variable "aws_security_group_id" {
  type = string
  description = "The Security Group Id "
}