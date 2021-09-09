# **Multiple State**

The state split is done for several reasons but one of the most important is speed of execution, as every time we run the terraform we scan the entire tfstate.

## How to use multiples states in a terraform repository.

We're going to use a simple code that creates a `s3` bucket to host the states, a simple `network` configuration and a `ec2` instance to use the network configs created.

Code tree:
```text
multiple-state
    ├── app
    │   ├── data.tf
    │   ├── ec2.tf
    │   └── providers.tf
    ├── networking
    │   ├── outputs.tf
    │   ├── providers.tf
    │   ├── route_tables.tf
    │   ├── subnets.tf
    │   ├── variables.tf
    │   └── vpc.tf
    └── prerequisites
        ├── providers.tf
        └── s3.tf
```

The s3 state will be located locally for obvious reasons. This bucket will be created to host the `network` and `app` states.

## providers.tf

Condfigure your providers.tf correctly to the scope. In this case the only difference beetwen `app/providers.tf` and `networking/providers.tf` is the `key` that name your state file:

app/providers.tf
```text
terraform {
  backend "s3" {
    bucket = "remote-terraform-mult-state-files"
    key    = "application.tf"
    region = "us-east-2"
  }
  required_version = "0.13.2"
}
```

networking/providers.tf

```text
terraform {
  backend "s3" {
    bucket = "remote-terraform-mult-state-files"
    key    = "networking.tf"
    region = "us-east-2"
  }
  required_version = "0.13.2"
}
```

This way once you provision all infra in networking/ a state will be created like this:

```text
s3://remote-terraform-mult-state-files/networking.tf
```

And the same will accours to app/
```text
s3://remote-terraform-mult-state-files/application.tf
```
After provisioning all infra you ,msut have two states, `networking.tf` and `application.tf` hosted in your bucket.

## Using remote state

The most important topic in this sample is the possibility to use the value from a state in another one. In this code we use the `subnet_id` and `environment` from networking.tf `state` to provision an ec2 instance that uses application.tf `state`. You can make it possible by doing:

- Mapping the state that you want to extract the values (networking.tf) in this case. You're going to use `terraform_remote_state` `data` to track the info from there.

```text
data "terraform_remote_state" "networking" {
  backend = "s3"
  config = {
    bucket = "remote-terraform-mult-state-files"
    key    = "networking.tf"
    region = "us-east-2"
  }
}
```
**NOTE:** *All information that you want to expose to another state must have an output section. In this case for subnet_id in `networking/outputs.tf` you should have something like this:*

```text
output "subnet_id" {
    value = aws_subnet.mult_state_sbn.id
}
```
Then the `terraform_remote_state` that you declared can see the value from the state.

## Usage
And finally we can use the outputs from outside state to another: Applied for `subnet_id` and `tags[name]`.

```text
resource "aws_instance" "web_app" {
  ami           = "ami-00399ec92321828f5"
  instance_type = "t3.micro"
  subnet_id     = data.terraform_remote_state.networking.outputs.subnet_id

  tags = {
    name = lower(data.terraform_remote_state.networking.outputs.environment)
  }
}
```

## Provision Infra

The commands to provision the infra are the same for all three dirs:

|Directory|Provision|
|:---| :---|
|app/|ec2|
|networking/| VPC, Subnet... (all network) |
|prerequisites/|s3 bucket|

*Remenber that you need to perform the provisioning in a right order. In this case:*

1. prerequisites/
2. networking/
3. app/

You will run fo reach of these dirs, in that order, the commands:

```shell
terraform init
terraform plan
terraform apply
```

And in the opposite order of creation you'll run the destroy:

```shell
terraform destroy
```
*If you try to destroy the networking stuff first propably it will timeout because ec2 instance is using the vpc and subnet stuff.*