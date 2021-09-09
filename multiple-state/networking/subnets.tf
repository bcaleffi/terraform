resource "aws_subnet" "mult_state_sbn" {
  vpc_id            = aws_vpc.mult_state_vpc.id
  cidr_block        = "10.0.1.0/24"

  tags = {
    name = "mult_state_sbn"
    env  = "dev"
  }
}