data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "remote-terraform-mult-state-files"
    key    = "networking.tf"
    region = "us-east-2"
  }
}