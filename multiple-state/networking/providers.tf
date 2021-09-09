provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "remote-terraform-mult-state-files"
    key    = "networking.tf"
    region = "us-east-2"
  }
  required_version = "0.13.2"
}