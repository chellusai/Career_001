provider "aws" {
  region = var.region_name
}

terraform {
  backend "s3" {
    bucket = "ctindiawin"
    key    = "function-tfstate"
    region = "us-east-1"
  }
}


resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_subnet" "public-subnet" {
  count = length(var.public_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = "${element(var.public_cidr_block, count.index + 1)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_route_table" "mrt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  
  tags = {
    Name = "${var.vpc_name}-mrt"
  }
}

resource "aws_subnet" "private-subnet" {
  count = length(var.private_cidr_block)
  vpc_id     = aws_vpc.main.id
  cidr_block = "${element(var.private_cidr_block, count.index + 1)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index + 1}"
  }
}
resource "aws_route_table" "pmrt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-pmrt"
  }
}