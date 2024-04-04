provider "aws" {}

# Frontend
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

# Mongodb
resource "aws_instance" "mongodb" {
  ami                    = "ami-0f3c7d07486cad139"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-062c9c57661d1416a"]
  tags                   = {
    Name    = "mongodb"
    Project = "roboshop"
  }
}

resource "aws_route53_record" "mongodb" {
  zone_id = "Z09678453PONOT92KJ2ZM"
  name    = "mongodb-dev.learntechnology.cloud"
  type    = "A"
  ttl     = 10
  records = [aws_instance.mongodb.private_ip]
}

# Catalogue
resource "aws_instance" "catalogue" {
  ami                    = "ami-0f3c7d07486cad139"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-062c9c57661d1416a"]
  tags                   = {
    Name    = "catalogue"
    Project = "roboshop"
  }
}

resource "aws_route53_record" "catalogue" {
  zone_id = "Z09678453PONOT92KJ2ZM"
  name    = "catalogue-dev.learntechnology.cloud"
  type    = "A"
  ttl     = 10
  records = [aws_instance.catalogue.private_ip]
}

# Redis
resource "aws_instance" "redis" {
  ami                    = "ami-0f3c7d07486cad139"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-062c9c57661d1416a"]
  tags                   = {
    Name    = "redis"
    Project = "roboshop"
  }
}

resource "aws_route53_record" "redis" {
  zone_id = "Z09678453PONOT92KJ2ZM"
  name    = "redis-dev.learntechnology.cloud"
  type    = "A"
  ttl     = 10
  records = [aws_instance.redis.private_ip]
}

# user
resource "aws_instance" "user" {
  ami                    = "ami-0f3c7d07486cad139"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-062c9c57661d1416a"]
  tags                   = {
    Name    = "user"
    Project = "roboshop"
  }
}

resource "aws_route53_record" "user" {
  zone_id = "Z09678453PONOT92KJ2ZM"
  name    = "user-dev.learntechnology.cloud"
  type    = "A"
  ttl     = 10
  records = [aws_instance.user.private_ip]
}

# Cart
resource "aws_instance" "cart" {
  ami                    = "ami-0f3c7d07486cad139"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-062c9c57661d1416a"]
  tags                   = {
    Name    = "cart"
    Project = "roboshop"
  }
}

resource "aws_route53_record" "cart" {
  zone_id = "Z09678453PONOT92KJ2ZM"
  name    = "cart-dev.learntechnology.cloud"
  type    = "A"
  ttl     = 10
  records = [aws_instance.cart.private_ip]
}

# MYSQL
resource "aws_instance" "mysql" {
  ami                    = "ami-0f3c7d07486cad139"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-062c9c57661d1416a"]
  tags                   = {
    Name    = "mysql"
    Project = "roboshop"
  }
}

resource "aws_route53_record" "mysql" {
  zone_id = "Z09678453PONOT92KJ2ZM"
  name    = "mysql-dev.learntechnology.cloud"
  type    = "A"
  ttl     = 10
  records = [aws_instance.mysql.private_ip]
}

# Shipping
resource "aws_instance" "shipping" {
  ami                    = "ami-0f3c7d07486cad139"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-062c9c57661d1416a"]
  tags                   = {
    Name    = "shipping"
    Project = "roboshop"
  }
}

resource "aws_route53_record" "shipping" {
  zone_id = "Z09678453PONOT92KJ2ZM"
  name    = "shipping-dev.learntechnology.cloud"
  type    = "A"
  ttl     = 10
  records = [aws_instance.shipping.private_ip]
}

# RabbitMQ
resource "aws_instance" "rabbitmq" {
  ami                    = "ami-0f3c7d07486cad139"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-062c9c57661d1416a"]
  tags                   = {
    Name    = "rabbitmq"
    Project = "roboshop"
  }
}

resource "aws_route53_record" "rabbitmq" {
  zone_id = "Z09678453PONOT92KJ2ZM"
  name    = "rabbitmq-dev.learntechnology.cloud"
  type    = "A"
  ttl     = 10
  records = [aws_instance.rabbitmq.private_ip]
}

# payment
resource "aws_instance" "payment" {
  ami                    = "ami-0f3c7d07486cad139"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-062c9c57661d1416a"]
  tags                   = {
    Name    = "payment"
    Project = "roboshop"
  }
}

resource "aws_route53_record" "payment" {
  zone_id = "Z09678453PONOT92KJ2ZM"
  name    = "payment-dev.learntechnology.cloud"
  type    = "A"
  ttl     = 10
  records = [aws_instance.payment.private_ip]
}

# Dispatch
resource "aws_instance" "dispatch" {
  ami                    = "ami-0f3c7d07486cad139"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-062c9c57661d1416a"]
  tags                   = {
    Name    = "dispatch"
    Project = "roboshop"
  }
}

resource "aws_route53_record" "dispatch" {
  zone_id = "Z09678453PONOT92KJ2ZM"
  name    = "dispatch-dev.learntechnology.cloud"
  type    = "A"
  ttl     = 10
  records = [aws_instance.dispatch.private_ip]
}