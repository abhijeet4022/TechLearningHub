resource "aws_lb_target_group" "web-tg" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom-vpc.id # Replace with your VPC ID
  health_check {
    path                = "/index.html"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

resource "aws_lb_listener" "webtg-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }
}

resource "aws_lb" "alb" { #aws_lb.alb.name
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb-sg.id]

  enable_deletion_protection = false
  #enable_http2                     = true
  enable_cross_zone_load_balancing = true

  subnets = [aws_subnet.public-sub-1.id, aws_subnet.public-sub-2.id] # Replace with your subnet IDs
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.web-autoscaling.name
  lb_target_group_arn    = aws_lb_target_group.web-tg.arn
}