# Allocating Elastip IP
resource "aws_eip" "elastic-ip" {
  domain = "vpc"
  tags = {
    Name = "elastic-ip-1"
  }
}

# Creating NAT-Gateway
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elastic-ip.id
  subnet_id     = aws_subnet.public-sub-1.id
  depends_on    = [aws_internet_gateway.custom-igw]
  tags = {
    Name = "Nat-GW"
  }
}

# Route Table setup for NAT-Gateway
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.custom-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "Private-RT-1"
  }
}

# Private Route Associations 
resource "aws_route_table_association" "private-sub-1a" {
  subnet_id      = aws_subnet.private-sub-1.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-sub-2a" {
  subnet_id      = aws_subnet.private-sub-2.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private-sub-3a" {
  subnet_id      = aws_subnet.private-sub-3.id
  route_table_id = aws_route_table.private-rt.id
}

