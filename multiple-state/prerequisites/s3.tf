resource "aws_s3_bucket" "terraform_mult_state" {
  bucket = "remote-terraform-mult-state-files"
  acl    = "private"

  tags = {
    name = "remote-terraform-mult-state-files"
    env  = "dev"
  }
}