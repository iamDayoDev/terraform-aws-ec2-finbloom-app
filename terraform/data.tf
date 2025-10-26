data "aws_availability_zones" "azs" {
  state = "available"
  filter {
    name   = "region_name"
    values = [var.aws_region]
  }
  filter {
    name   = "zone-name"
    values = ["${var.aws_region}a", "${var.aws_region}b"]
  }
  depends_on = [
    aws_vpc.main_vpc
  ]
}