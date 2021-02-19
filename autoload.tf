resource "aws_security_group" "elb" {
  name = "terraform-example-elb"
  vpc_id   = "vpc-0ff4ab841a437776c"
  egress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_lb_target_group" "test" {
  name     = "tf-example-lb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-0ff4ab841a437776c"
}
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb.id]
  subnets            = ["subnet-009c735cb2b90fecd","subnet-0650e442f12bbb01c","subnet-0a487fa1e35ed75a4"]
}
resource "aws_lb_listener" "back_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:805556005655:certificate/62c4063a-9bcf-4364-8617-ce5ddd9c576d"
default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }
}
