
resource "aws_vpc" "tf-custom-vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "tf-custom-vpc"
  }
}

/*
    Dynamic Creation: The count attribute iterates over a list and creates a resource for each item in that list.
    In the subnet definition, count is set to the length of the subnet_cidrs list,
    meaning a subnet is created for each CIDR block specified in that list.
 */
resource "aws_subnet" "tf-public-subnet" {
  count      = length(var.subnet_cidrs)
  vpc_id     = aws_vpc.tf-custom-vpc.id
  cidr_block = var.subnet_cidrs[count.index]
  availability_zone = var.availability_zone[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "tf-public-subnet-${count.index + 1}"
  }
}


resource "aws_internet_gateway" "tf-internet-gateway" {
  vpc_id = aws_vpc.tf-custom-vpc.id
  tags = {
    Name = "tf-internet-gateway"
  }
}

resource "aws_route_table" "tf-route-table" {
  vpc_id = aws_vpc.tf-custom-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf-internet-gateway.id
  }

  tags = {
    Name = "Public route table"
  }
}

resource "aws_route_table_association" "tf-route-table-association" {
  count = length(var.subnet_cidrs)
  subnet_id = aws_subnet.tf-public-subnet[count.index].id
  route_table_id = aws_route_table.tf-route-table.id
}
