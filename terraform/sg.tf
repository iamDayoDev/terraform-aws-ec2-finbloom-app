resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Security group for the application"
  vpc_id      = aws_vpc.main_vpc.id

  # Allow SSH access
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow backend traffic from ALB
  ingress {
    description     = "Backend traffic from ALB"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  # Allow frontend traffic from ALB
  ingress {
    description     = "Frontend traffic from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tags["Project"]}-app-sg"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.tags["Project"]}-alb-sg"
  description = "ALB security group - allow HTTP and backend traffic from Internet"
  vpc_id      = aws_vpc.main_vpc.id

  # Allow HTTP from internet
  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow backend port from internet
  ingress {
    description = "Backend port from internet"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tags["Project"]}-alb-sg"
  }
}


resource "aws_security_group" "db_sg" {
  name        = "${var.tags["Project"]}-db-sg"
  description = "Database security group - allow PostgreSQL from app servers"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description     = "Allow PostgreSQL from app servers"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tags["Project"]}-db-sg"
  }
}
