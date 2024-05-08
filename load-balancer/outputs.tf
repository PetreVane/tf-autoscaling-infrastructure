
output "load-balancer-arn" {
  description = "The ARN of the Application Load Balancer."
  value = aws_lb.tf-application-load-balancer.arn
}

output "load-balancer-dns-name" {
  description = "The DNS name of the Application Load Balancer."
  value = aws_lb.tf-application-load-balancer.dns_name
}

output "load-balancer-type" {
  value = aws_lb.tf-application-load-balancer.load_balancer_type
}

output "load-balancer-name" {
  value = aws_lb.tf-application-load-balancer.name
}

output "load-balancer-arn-suffix" {
  value = aws_lb.tf-application-load-balancer.arn_suffix
}