provider "aws" {
  region = var.region_name
}

terraform {
  backend "s3" {
    bucket = "mybucket-red"
    key    = "function.tfstate"
    region = "us-east-1"
  }
}

resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block

  tags = {
    Name = var.vpc_tag_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.igw_tag_name
  }
}