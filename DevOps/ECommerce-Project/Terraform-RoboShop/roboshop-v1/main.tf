provider "aws" {}

resource "aws_instance" "frontend" {
  ami                    = "ami-0f3c7d07486cad139"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-062c9c57661d1416a"]
  tags                   = {
    Name    = "frontend"
    Project = "roboshop"
  }
}

resource "aws_route53_record" "frontend" {
  zone_id = "Z09678453PONOT92KJ2ZM"
  name    = "frontend-dev.learntechnology.cloud"
  type    = "A"
  ttl     = 10
  records = [aws_instance.frontend.private_ip]
}