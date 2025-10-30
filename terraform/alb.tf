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

resource "aws_alb_target_group" "frontend_tg" {
  name     = "${var.tags["Project"]}-frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
  deregistration_delay = 30

  health_check {
    path                = "/"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.tags["Project"]}-frontend-tg"
  }
}

resource "aws_alb_target_group" "backend_tg" {
  name     = "${var.tags["Project"]}-backend-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id
  deregistration_delay = 30

  health_check {
    path                = "/health"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.tags["Project"]}-backend-tg"
  }
}

resource "aws_alb_listener" "frontend_app_lb_listener" {
  load_balancer_arn = aws_alb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.frontend_tg.arn
  }
}

resource "aws_alb_listener" "backendapp_lb_listener" {
  load_balancer_arn = aws_alb.app_lb.arn
  port              = "5000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.backend_tg.arn
  }
}

resource "aws_alb_target_group_attachment" "frontend_server_attachment" {
  target_group_arn = aws_alb_target_group.frontend_tg.arn
  target_id        = aws_instance.app_server.id
  port             = 80
}

resource "aws_alb_target_group_attachment" "backend_server_attachment" {
  target_group_arn = aws_alb_target_group.backend_tg.arn
  target_id        = aws_instance.app_server.id
  port             = 5000
}

