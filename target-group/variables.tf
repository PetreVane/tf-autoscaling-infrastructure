

variable "vpc-id" {
  type = string
  description = "The ID of the VPC where the target group will be created."
}

variable "port" {
  type = number
  description = "The port on which the target group will redirect connections"
}

variable "protocol" {
  type = string
  description = "The protocol used by target group"
  default = "HTTP"
}

variable "target-type" {
  type = string
  description = "The target type used by the Target Group"
  default = "instance"
}

variable "path" {
  type = string
  description = "The path used by target group to redirect connections"
  default = "/"
}