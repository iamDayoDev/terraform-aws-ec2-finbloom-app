resource "aws_alb" "app_lb" {
  name               = "${var.tags["Project"]}-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  enable_deletion_protection = false

  tags = {
    Name = "${var.tags["Project"]}-app-lb"
  }
}

resource "aws_alb_target_group" "app_tg" {
  name     = "${var.tags["Project"]}-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.tags["Project"]}-app-tg"
  }
}

resource "aws_alb_listener" "app_lb_listener" {
  load_balancer_arn = aws_alb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.app_tg.arn
  }
}

