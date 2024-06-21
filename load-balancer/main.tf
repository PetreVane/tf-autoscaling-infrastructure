resource "random_id" "alb_id" {
  byte_length = 4
}


resource "aws_lb" "tf-application-load-balancer" {
  name = "tf-alb-${random_id.alb_id.hex}"
  internal = false
  load_balancer_type = "application"
  security_groups = [var.security_group_id]
  subnets = var.subnet_ids

  tags = {
    Name = "tf-application-load-balancer"
  }
}

resource "aws_lb_listener" "tf-http-listener" {
  load_balancer_arn = aws_lb.tf-application-load-balancer.arn
  port = var.port
  protocol = var.protocol

  default_action {
    type = "forward"
    target_group_arn = var.target_group_arn
  }
}