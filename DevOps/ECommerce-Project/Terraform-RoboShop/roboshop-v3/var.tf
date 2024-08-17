variable "zone_id" {
  default = "Z09678453PONOT92KJ2ZM"
}

variable "security_group" {
  default = ["sg-062c9c57661d1416a"]
}

variable "project" {
  default = "roboshop"
}

variable "components" {
  default = {
    frontend = {
      name          = "frontend"
      instance_type = "t2.micro"
    }
    mongodb = {
      name          = "mongodb"
      instance_type = "t2.micro"
    }
    catalogue = {
      name          = "catalogue"
      instance_type = "t2.micro"
    }
    redis = {
      name          = "redis"
      instance_type = "t2.micro"
    }
    user = {
      name          = "user"
      instance_type = "t2.micro"
    }
    cart = {
      name          = "cart"
      instance_type = "t2.micro"
    }
    mysql = {
      name          = "mysql"
      instance_type = "t3.small"
    }
    shipping = {
      name          = "shipping"
      instance_type = "t2.micro"
    }
    rabbitmq = {
      name          = "rabbitmq"
      instance_type = "t2.micro"
    }
    payment = {
      name          = "payment"
      instance_type = "t2.micro"
    }
    dispatch = {
      name          = "dispatch"
      instance_type = "t2.micro"
    }
  }
}
