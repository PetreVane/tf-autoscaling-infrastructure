
variable "expected_bucket_arn" {
  type = string
  description = "The arn of the bucket on which the permission policy applies"
}

variable "expected_sns_topic_arn" {
  type = string
  description = "The arn of the topic on which lambda failures are published"
}