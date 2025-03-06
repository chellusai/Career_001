resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.rt_cidr_block
    gateway_id = aws_internet_gateway.example.id
  }

  tags = {
    Name = var.rt_tag_name
  }
}