provider "aws" {
  region = var.region_name
}

terraform {
  backend "s3" {
    bucket = "anumulasetty.xyzx"
    key    = "mybackend"
    region = "us-east-1"
  }
}


resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.igw_tag
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr_block

  tags = {
    Name = var.subnet_tag_name
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.rt_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.rt_name
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}
resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  egress {
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    cidr_blocks       = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_sg"
  }
}