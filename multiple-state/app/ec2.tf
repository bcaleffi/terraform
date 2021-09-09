resource "aws_instance" "web_app" {
  ami           = "ami-00399ec92321828f5"
  instance_type = "t3.micro"
  subnet_id     = data.terraform_remote_state.networking.outputs.subnet_id

  tags = {
    name = lower(data.terraform_remote_state.networking.outputs.environment)
  }
}