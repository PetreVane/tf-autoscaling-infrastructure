
variable "launch-template-version" {
  type = string
  description = "The version of the launch template used by ASG"
}

# variable "alb-target-group-arn" {
#   type = string
#   description = "The arn of the target group"
# }

variable "launch-template-id" {
  description = "The ID of the launch template to use with the auto scaling group"
  type        = string
}

variable "subnet-ids" {
  description = "List of subnet IDs for the auto scaling group to cover"
  type        = list(string)
}

variable "min-size" {
  description = "The minimum size of the auto scaling group"
  type        = number
}

variable "max-size" {
  description = "The maximum size of the auto scaling group"
  type        = number
}

variable "desired-capacity" {
  description = "The desired number of instances in the auto scaling group"
  type        = number
}
