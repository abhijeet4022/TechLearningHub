terraform {
  backend "s3" {
    bucket = "abhi8434"
    key    = "route53/terraform.tfstate"
    region = "us-east-1"


  }
}