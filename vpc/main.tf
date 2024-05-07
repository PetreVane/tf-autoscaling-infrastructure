
resource "aws_vpc" "tf-fourth-custom-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "tf-fourth-custom-vpc"
  }
}

resource "aws_subnet" "tf-public-subnet-1" {
  vpc_id     = aws_vpc.tf-fourth-custom-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.az1
  map_public_ip_on_launch = true
  tags = {
    Name = "Tf-public-subnet-1"
  }
}

resource "aws_subnet" "tf-public_subnet_2" {
  vpc_id     = aws_vpc.tf-fourth-custom-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = var.az2
  map_public_ip_on_launch = true
  tags = {
    Name = "Tf-public-subnet-1"
  }
}

resource "aws_internet_gateway" "tf-internet-gateway" {
  vpc_id = aws_vpc.tf-fourth-custom-vpc.id
  tags = {
    Name = "tf-internet-gateway"
  }
}

resource "aws_route_table" "tf-route-table" {
  vpc_id = aws_vpc.tf-fourth-custom-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf-internet-gateway.id
  }

  tags = {
    Name = "Public route table"
  }
}

resource "aws_route_table_association" "tf-route-table-assoc-1" {
  route_table_id = aws_route_table.tf-route-table.id
  subnet_id = aws_subnet.tf-public-subnet-1.id
}

resource "aws_route_table_association" "tf-route-table-assoc-2" {
  route_table_id = aws_route_table.tf-route-table.id
  subnet_id = aws_subnet.tf-public_subnet_2.id
}