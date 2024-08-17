# Internet VPC
resource "aws_vpc" "custom-vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "Custom-VPC"
  }
}

# Subnets
#public-sub-1
resource "aws_subnet" "public-sub-1" {
  vpc_id                  = aws_vpc.custom-vpc.id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.AZ-C

  tags = {
    Name = "public-subnet-1"
  }
}

#public-sub-2
resource "aws_subnet" "public-sub-2" {
  vpc_id                  = aws_vpc.custom-vpc.id
  cidr_block              = "10.0.11.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.AZ-B

  tags = {
    Name = "public-subnet-2"
  }
}

#public-sub-3
resource "aws_subnet" "public-sub-3" {
  vpc_id                  = aws_vpc.custom-vpc.id
  cidr_block              = "10.0.12.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.AZ-C

  tags = {
    Name = "public-subnet-3"
  }
}

#private-subnet-1
resource "aws_subnet" "private-sub-1" {
  vpc_id                  = aws_vpc.custom-vpc.id
  cidr_block              = "10.0.20.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = var.AZ-A

  tags = {
    Name = "private-subnet-1"
  }
}

#private-subnet-2
resource "aws_subnet" "private-sub-2" {
  vpc_id                  = aws_vpc.custom-vpc.id
  cidr_block              = "10.0.21.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = var.AZ-B

  tags = {
    Name = "private-subnet-2"
  }
}

# private-subnet-3
resource "aws_subnet" "private-sub-3" {
  vpc_id                  = aws_vpc.custom-vpc.id
  cidr_block              = "10.0.22.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = var.AZ-C

  tags = {
    Name = "private-subnet-3"
  }
}

# Internet GW
resource "aws_internet_gateway" "custom-igw" {
  vpc_id = aws_vpc.custom-vpc.id

  tags = {
    Name = "Custom-IGW"
  }
}

# route tables
# Public Route table.
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.custom-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.custom-igw.id
  }

  tags = {
    Name = "Public-RT-1"
  }
}



# Public Route Associations 
resource "aws_route_table_association" "public-sub-1a" {
  subnet_id      = aws_subnet.public-sub-1.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-sub-2a" {
  subnet_id      = aws_subnet.public-sub-2.id
  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "public-sub-3a" {
  subnet_id      = aws_subnet.public-sub-3.id
  route_table_id = aws_route_table.public-rt.id
}




