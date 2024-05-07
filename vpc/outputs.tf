output "vpc_id" {
  value = aws_vpc.tf-fourth-custom-vpc.id
}

output "tf-public-subnet-1-id" {
  value = aws_subnet.tf-public-subnet-1.id
}

output "tf-public-subnet-2-id" {
  value = aws_subnet.tf-public_subnet_2.id
}