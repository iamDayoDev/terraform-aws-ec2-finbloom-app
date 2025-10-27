output "app_server-1_public_ip" {
  description = "The public IP address of the first application server"
  value       = aws_instance.app_server.public_ip
}

output "app_server-2_public_ip" {
  description = "The public IP address of the second application server"
  value       = aws_instance.app_server_2.public_ip
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_alb.app_lb.dns_name
}

output "db_instance_endpoint" {
  description = "The endpoint of the RDS PostgreSQL instance"
  value       = aws_db_instance.postgres_db.endpoint
}