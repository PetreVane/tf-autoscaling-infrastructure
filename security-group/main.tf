
resource "aws_security_group" "tf-sg-web_allows_8080" {
  name = "tf-allows-8080"
  description = "Allows access to port 8080"
  vpc_id = var.expected_vpc_id

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol = "-1" # denies outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

}
