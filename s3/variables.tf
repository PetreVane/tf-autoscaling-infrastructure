variable "bucket_name" {
  description = "The name of the S3 bucket to create."
  type        = string
}

variable "jar_file_name" {
  description = "The name of the jar file to upload."
  type        = string
}

variable "jar_file_path" {
  description = "The local path for the jar file to upload."
  type        = string
}
