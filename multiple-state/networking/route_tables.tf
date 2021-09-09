resource "aws_internet_gateway" "mult_state_ig" {
  vpc_id = aws_vpc.mult_state_vpc.id

  tags = {
    name = "mult_state_ig"
    env  = "dev"
  }
}

resource "aws_route_table" "mult_state_rt" {
  vpc_id = aws_vpc.mult_state_vpc.id

  tags = {
    name = "mult_state_rt"
    env  = "dev"
  }
}

resource "aws_route" "mult_state_r" {
  route_table_id  = aws_route_table.mult_state_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id      = aws_internet_gateway.mult_state_ig.id
}

resource "aws_route_table_association" "mult_state_pa" {
  subnet_id      = aws_subnet.mult_state_sbn.id
  route_table_id = aws_route_table.mult_state_rt.id
}