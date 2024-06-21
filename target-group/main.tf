
resource "random_id" "generator" {
  byte_length = 4
}

resource "aws_lb_target_group" "tf-target-group" {

  name = "tf-alb-target-group-${random_id.generator.hex}"
  port = var.port
  protocol = var.protocol
  vpc_id = var.vpc-id
  target_type = var.target-type

  health_check {
    enabled = true
    interval = 30
    port = var.port
    path = var.path
    protocol = var.protocol
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 5 // this will be interesting - read the comment bellow
    matcher = "200"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "tf-alb-target-group"
  }
  /*
  Modifying the timeout value will change how connections are established. When using an app load balancer, if there is
  a mismatch between the timeout defined by terraform and the timeout defined in application.properties file of the java
  app, the connection will fail, which will trigger a reconnect. And if this happens, when there is a dynamic scaling defined in the
  autoscaling group, which uses requests count as trigger for autoscaling, then the mismatched values will most certainly trigger
  a cloud watch alarm, which in turn will trigger the autoscaling group to deploy one more instance, as long as the desired
  capacity is lower than the max-size.
   */

}
