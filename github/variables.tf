variable "region" {
  description = "The AWS region"
  type = string
}

variable "github_token" {
  description = "Github access token"
  type = string
}

variable "github_repo" {
  description = "The name of the Github repository where the actions workflow file is stored"
  type = string
  default = "PetreVane/dummy-app"
}

variable "s3_bucket_arn" {
  description = "The bucket arn where the compiled jar file will be stored"
  type = string
}

variable "s3_bucket_id" {
  description = "The bucket id where the compiled jar file will be stored"
  type = string
}

variable "jar_file_name" {
  description = "The name of the jar file to upload."
  type        = string
  default     = "dummy-webapp.jar"
}

variable "create_oidc_provider" {
  description = "Whether to create the OIDC provider or use an existing one"
  type = bool
  default = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type = map(string)
  default = {}
}