variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "region" {
  type = string
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1  = "ami-09538990a0c4fe9be"
    us-east-2  = "ami-098dd3a86ea110896"
    ap-south-1 = "ami-021f7978361c18b01"
  }

}