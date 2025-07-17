#Create VPC
resource "aws_vpc" "uat-vpc" {
  cidr_block = var.vpc-cidr-range
  tags = {
    Name = var.vpc-name-tag
  }
}