resource "aws_security_group" "sg" {
  vpc_id      = aws_vpc.custom-vpc.id
  name        = "webserver"
  description = "Allow-ssh-web"
  dynamic "ingress" {
    for_each = [22, 80, 443]
    iterator = port
    content {
      description      = "TLS from VPC"
      from_port        = port.value
      to_port          = port.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "webserver-sg"
  }

}

output "security_group_id" {
  value = aws_security_group.sg.id
}
