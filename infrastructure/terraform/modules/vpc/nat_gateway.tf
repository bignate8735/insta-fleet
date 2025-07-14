resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "${var.project}-nat-eip"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.this]

  tags = {
    Name = "${var.project}-natgw"
  }
}