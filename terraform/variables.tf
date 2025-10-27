variable "aws_region" {
  default = "us-east-1"
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "Dev"
    Project     = "Finbloom"
  }
}

variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
  default = "hng-devops"
}