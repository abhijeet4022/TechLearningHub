provider "aws" {
  region = "us-east-1"
}

variable "ami" {
  default = "ami-0f3c7d07486cad139"
}

variable "vpc_security_group_ids" {
  default = ["sg-062c9c57661d1416a"]
}

variable "zone_id" {
  default = "Z09678453PONOT92KJ2ZM"
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


# Instance Creation
resource "aws_instance" "instance" {
  for_each               = var.components
  ami                    = var.ami
  instance_type          = lookup(each.value, "instance_type", null )
  vpc_security_group_ids = var.vpc_security_group_ids
  tags                   = {
    Name    = lookup(each.value, "name", null)
    Project = "roboshop"
    Env = "Dev"
  }
#  ebs_block_device {
#    device_name = ""
#    tags        = {
#      Name        = lookup(each.value, "name", null)
#      Environment = "Production"
#      Project = "roboshop"
#      Env = "Dev"
#    }
#  }
}

  resource "aws_route53_record" "records" {
    for_each = var.components
    zone_id  = var.zone_id
    name     = "${lookup(each.value, "name", null)}.learntechnology.cloud"
    type     = "A"
    ttl      = 10
    records  = [lookup(lookup(aws_instance.instance, each.key, null ), "private_ip", null)]
  }


#  output "records" {
#    value = aws_instance.instance
#  }
#  output "records-cart" {
#    value = aws_instance.instance["cart"]
#  }

#output "public-ip" {
#  value = lookup(lookup(aws_instance.instance, "cart", null ), "public_ip", null)
#}
output "root-disk" {
  value = lookup(lookup(aws_instance.instance, "cart", null ), "root_block_device", null)
}

#output "root-disk-device-name" {
#  value = lookup(lookup(aws_instance.instance, "cart", null).root_block_device[0], "device_name", null)
#}
output "root-disk-device-name" {
  value = lookup(lookup(aws_instance.instance, "cart", null) "root_block_device", null)
}

output "root-disk-devce" {
  value = aws_instance.instance["cart"].root_block_device[0]
}



#    device_name = "/dev/sda1"  # Modify this to match your root volume device name
#    volume_type = "gp2"        # Specify the desired EBS volume type

