terraform {
  backend "s3" {
    bucket = "abhi8434"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"

  }
}