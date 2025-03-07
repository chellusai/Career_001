provider "aws" {
  region = var.region_name
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

resource "aws_subnet" "public" {
  count = 3
  vpc_id     = aws_vpc.main.id
  cidr_block = "${element(var.public_cidr_block, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = {
    Name = "${var.vpc_name}-public_sbnet-${count.index}"
  }
}

resource "aws_route_table" "mrt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-public-mrt"
  }
}

