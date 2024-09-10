# networking.tf

# Create a VPC
resource "aws_vpc" "lab_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "lab_vpc"
  }
}

# Create a subnet inside VPC
resource "aws_subnet" "lab_subnet" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "lab_vpc"
  }
}

# Create Security Group for SSH
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic; Allow all outbound traffic"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Internet Gateway for VPC
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.lab_vpc.id
}

# Create default route table for VPC
resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.lab_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name = "Default route table"
  }
}