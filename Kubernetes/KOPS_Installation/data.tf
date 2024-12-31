data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
	name   = "name"
	values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
	name   = "virtualization-type"
	values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Data source to get the VPC ID by name
data "aws_vpc" "default_vpc" {
  filter {
	name   = "tag:Name"
	values = ["default-vpc"] # Replace with your VPC name
  }
}