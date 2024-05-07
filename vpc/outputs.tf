output "vpc_id" {
  value = aws_vpc.tf-custom-vpc.id
}

output "subnets_ids" {
  value = aws_subnet.tf-public-subnet[*].id
  description = "List of subnets ids"
}

# output "tf-public-subnet-1-id" {
#   value = aws_subnet.tf-public-subnet.id
# }
#
# output "tf-public-subnet-2-id" {
#   value = aws_subnet.tf-public_subnet_2.id
# }