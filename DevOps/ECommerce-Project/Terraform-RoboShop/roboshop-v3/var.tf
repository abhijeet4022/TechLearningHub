variable "zone_id" {
  default = ""
}

variable "security_group" {
  default = ""
}

variable "project" {
  default = "roboshop"
}

variable "components" {
  default = {
    frontend = {
      name = frontend
      instance_type = "t2.micro"
    }
  }
}
