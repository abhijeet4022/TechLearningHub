provider "aws" {
  region     = "us-east-1" #EC2 machine Region
  access_key = var.access_key
  secret_key = var.secret_key
}
