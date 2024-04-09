# data "aws_ip_ranges" "ips" {
#   regions  = ["us-east-1"]
#   services = ["ec2"]

# }


resource "aws_security_group" "sg" {
  name        = "terraform-sg"
  description = "Allow TLS inbound traffic"
  dynamic "ingress" {
    for_each = [22, 80, 443]
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      # cidr_blocks = ["${data.aws_ip_ranges.ips.cidr_blocks}"]
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
    Name = "terraform-sg"
  }
}

output "security_group_id" {
  value = ["${aws_security_group.sg.id}"]

}