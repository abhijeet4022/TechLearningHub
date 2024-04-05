provider "aws" {
  region = "us-east-1"
}

variable "ami" {
  default = "ami-0f3c7d07486cad139"
}

variable "vpc_security_group_ids" {
  default = ["sg-062c9c57661d1416a"]
}

variable "components" {
  default = {
    frontend  = { name = "frontend-dev", instance_type = "t2.micro" }
    mongodb   = { name = "mongodb-dev", instance_type = "t2.micro" }
    catalogue = { name = "catalogue-dev", instance_type = "t2.micro" }
    redis     = { name = "redis-dev", instance_type = "t2.micro" }
    user      = { name = "user-dev", instance_type = "t2.micro" }
    cart      = { name = "cart-dev", instance_type = "t2.micro" }
    mysql     = { name = "mysql-dev", instance_type = "t3.small" }
    shipping  = { name = "shipping-dev", instance_type = "t2.micro" }
    rabbitmq  = { name = "rabbitmq-dev", instance_type = "t2.micro" }
    payment   = { name = "payment-dev", instance_type = "t2.micro" }
    dispatch  = { name = "dispatch", instance_type = "t2.micro" }
  }
}


# Frontend
resource "aws_instance" "instance" {
  for_each               = var.components
  ami                    = var.ami
  instance_type          = lookup(each.value, "instance_type", null )
  vpc_security_group_ids = var.vpc_security_group_ids
  tags                   = {
    Name    = lookup(each.value, "name", null)
    Project = "roboshop"
  }
}

#resource "aws_route53_record" "frontend" {
#  zone_id = "Z09678453PONOT92KJ2ZM"
#  name    = "frontend-dev.learntechnology.cloud"
#  type    = "A"
#  ttl     = 10
#  records = [aws_instance.frontend.private_ip]
#}

