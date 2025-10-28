resource "aws_alb" "app_lb" {
  // ...existing code...
}

resource "aws_alb_target_group" "frontend_tg" {
  name                 = "${var.tags["Project"]}-frontend-tg"
  port                 = 80
  protocol            = "HTTP"
  vpc_id              = aws_vpc.main_vpc.id
  deregistration_delay = 30  # Reduce deregistration delay

  health_check {
    path                = "/"
    interval            = 15  # Reduced interval
    timeout             = 5
    healthy_threshold   = 2   # Reduced threshold
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.tags["Project"]}-frontend-tg"
  }
}

resource "aws_alb_target_group" "backend_tg" {
  name                 = "${var.tags["Project"]}-backend-tg"
  port                 = 5000
  protocol            = "HTTP"
  vpc_id              = aws_vpc.main_vpc.id
  deregistration_delay = 30  # Reduce deregistration delay

  health_check {
    path                = "/health"  # Use a specific health endpoint
    interval            = 15         # Reduced interval
    timeout             = 5
    healthy_threshold   = 2          # Reduced threshold
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.tags["Project"]}-backend-tg"
  }
}


