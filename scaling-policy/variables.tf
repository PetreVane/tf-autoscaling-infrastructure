
variable "autoscaling-group-name" {
  type = string
  description = "The name of the Auto Scaling Group to which the policy will apply."
}

variable "target-group-name" {
  type = string
  description = "The name of the target group"
}

variable "target-group-id" {
  type = string
  description = "The id of the target group"
}

variable "load-balancer-type" {
  type = string
  description = "The ALB type"
}
variable "load-balancer-arn" {
  type = string
  description = "The ARN of the ALB"
}

variable "load-balancer-name" {
  type = string
  description = "The name of the ALB"
}

variable "load-balancer-id" {
  type = string
  description = "The ALB id"
}

