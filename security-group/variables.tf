
variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created."
  type        = string
}

variable "port" {
  description = "The port number on which incoming traffic is allowed"
  type = number
}