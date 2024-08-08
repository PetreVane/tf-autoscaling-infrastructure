variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "instance_type" {
  type        = string
  description = "The ec2 instance type"
  default     = "t2.micro"
}

variable "port" {
  description = "The port number on which incoming traffic is allowed on SG and ALB"
  type        = number
  default     = 80
}