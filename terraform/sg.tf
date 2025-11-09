###############################
# APP SERVER SECURITY GROUP
###############################
resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Security group for application servers"
  vpc_id      = aws_vpc.main_vpc.id

  # SSH from anywhere (optional)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Backend API access (Port 5000) — allow ALB + frontend + local testing
  ingress {
    description = "Backend API from ALB and Frontend"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"

    security_groups = [
      aws_security_group.alb_sg.id, # ALB → backend
    ]

    cidr_blocks = [
      "0.0.0.0/0", # TEMPORARY — allows local curl, frontend public IP, etc.
      # REPLACE THIS LATER with:
      # aws_instance.frontend.private_ip/cidr
    ]
  }

  # Optional: allow HTTP from ALB to EC2 (only if app also serves on port 80)
  ingress {
    description     = "Frontend traffic forwarded from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tags["Project"]}-app-sg"
  }
}


###############################
# APPLICATION LOAD BALANCER SG
###############################
resource "aws_security_group" "alb_sg" {
  name        = "${var.tags["Project"]}-alb-sg"
  description = "ALB security group"
  vpc_id      = aws_vpc.main_vpc.id

  # Public HTTP access
  ingress {
    description = "Public HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ✅ DO NOT expose backend port 5000 to internet
  # Traffic should route internally ALB → app_sg only

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.tags["Project"]}-alb-sg"
  }
}


###############################
# DATABASE SECURITY GROUP
###############################
resource "aws_security_group" "db_sg" {
  name        = "${var.tags["Project"]}-db-sg"
  description = "Allow PostgreSQL from application tier"
  vpc_id      = aws_vpc.main_vpc.id



  # Only the app servers can connect to DB
  ingress {
    description     = "PostgreSQL"
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
