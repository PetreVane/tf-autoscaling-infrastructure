
variable "security_group_id" {
  type = string
  description = "The security group id"
}

variable "subnet_ids" {
  type = list(string)
  description = "The list of subnet ids used by the ALB"
}

variable "port" {
  type = number
  description = "The port on which the ALB will listen for connections"
}

variable "protocol" {
  type = string
  description = "The protocol used by ALB"
  default = "HTTP"
}

variable "target_group_arn" {
  type = string
  description = "The ARN of the target group toward which the ALB will redirect connections"
}