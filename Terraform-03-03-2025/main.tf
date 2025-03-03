#### First terraform script for vpc

#Provider
provider "aws" {
  region = "us-east-1"
}

#Vpc
resource "aws_vpc" "ibm-vpc" {
  cidr_block       = "10.10.0.0/16"
  enable_dns_hostnames = "true"

  tags = {
    Name = "ibm-vpc"
  }
}

#IGW
resource "aws_internet_gateway" "ibm-igw" {
  vpc_id = aws_vpc.ibm-vpc.id

  tags = {
    Name = "ibm-igw"
  }
}

#Subnet
resource "aws_subnet" "ibm-public-subnet" {
  vpc_id     = aws_vpc.ibm-vpc.id
  cidr_block = "10.10.1.0/24"

  tags = {
    Name = "ibm-public-subnet"
  }
}

#Route Table
resource "aws_route_table" "ibm-mrt" {
  vpc_id = aws_vpc.ibm-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ibm-igw.id
  }

  tags = {
    Name = "ibm-mrt"
  }
}

#RT Asso
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.ibm-public-subnet.id
  route_table_id = aws_route_table.ibm-mrt.id
}

#Scurity
resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.ibm-vpc.id

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