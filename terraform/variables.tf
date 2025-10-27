variable "aws_region" {
  default = "us-east-1"
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "Dev"
    Project     = "finbloom"
  }
}

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
  default     = "hng-devops"
}

variable "db_name" {
  default = "finbloomdb" # Database name
}

variable "db_username" {
  description = "The database admin username"
  type        = string
  default     = "finbloomadmin"
}

variable "db_password" {
  description = "The database admin password"
  type        = string
  default     = "postgres123"
}

