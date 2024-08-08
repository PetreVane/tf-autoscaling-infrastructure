
resource "aws_security_group" "tf-security-group" {
  name = "tf-security-group"
  description = "Security group for applications allowing HTTP traffic on port 8080 and SSH access on port 22"
  vpc_id = var.vpc_id

  // Inbound rule for HTTP traffic on port 8080
  ingress {
    description = "HTTP"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Inbound rule for HTTP traffic on port 22
  ingress {
    description = "HTTP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Default rule for outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-security-group"
  }
}
