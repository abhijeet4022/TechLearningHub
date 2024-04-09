provider "aws" {
  region     = "us-east-1" #EC2 machine Region
  access_key = var.access_key
  secret_key = var.secret_key
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

# this is data source it will help to fetch the ami_id, instead of hardcore the ami_id.

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  # AMI_Name = ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-20230516
  # root_device_type = ebs
  # Virtualization type = HVM

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

output "ami-id" {
  value = data.aws_ami.ubuntu.id
}