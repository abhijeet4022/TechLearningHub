# Specifiying the terrafrom version
# Note: We can't use valiable here. 
terraform {
  required_version = "1.5.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.10.0"
    }
 }
}