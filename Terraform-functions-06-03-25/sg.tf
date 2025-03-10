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