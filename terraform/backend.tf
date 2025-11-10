terraform {
  backend "s3" {
    bucket         = "finbloom-s3-tf-state-1715"
    key            = "finbloom/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "finbloom-dynamodb-lock"
  }
}