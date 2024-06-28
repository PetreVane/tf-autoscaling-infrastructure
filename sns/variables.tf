
variable "notification_email" {
  description = "The email address on which to send notifications when lambda fails execution"
  type = string
  default = "testing@email.com"
}