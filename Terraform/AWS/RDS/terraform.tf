terraform {
  backend "s3" {
    bucket = "abhi8434"
    key    = "RDS/terraform.tfstate"
    region = "us-east-1"
  }
}