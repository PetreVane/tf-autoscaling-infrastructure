
output "load_balancer_arn" {
  description = "The ARN of the Application Load Balancer."
  value = aws_lb.tf-application-load-balancer.arn
}

output "load_balancer_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value = aws_lb.tf-application-load-balancer.dns_name
}