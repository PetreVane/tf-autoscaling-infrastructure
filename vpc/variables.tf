
variable "subnet_cidrs" {
  type = list(string)
  description = "List of CIDR blocks for subnets"
}

variable "vpc_cidr" {
  type = string
  description = "The VPC CIDR block"
}

variable "availability_zone" {
  type = list(string)
  description = "A list containing the availability zones in the region"
  default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}