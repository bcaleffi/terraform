resource "aws_vpc" "mult_state_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    name = "mult_state_vpc"
    env  = "dev"
  }
}