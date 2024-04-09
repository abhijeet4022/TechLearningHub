#Create one SG name WebServer
resource "aws_security_group" "webserver" {
  name        = "webserver"
  description = "Allow http & ssh inbound traffic"

  # We are using dynamic block beasuse we have to pass multiple value for multiple ports.
  dynamic "ingress" {
    for_each = var.ports
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
  # Create outbound traffic by default all denied.
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "WebServer"
  }

}

output "SGDetails" {
  value = aws_security_group.webserver.id
}
