resource "aws_s3_bucket" "abhijeet8434" {
  bucket = "abhijeet8434"
  tags = {
    Name        = "abhijeet8434"
    Environment = "terraform_creation"
  }
}

output "s3-bucket-name" {
    value = aws_s3_bucket.abhijeet8434.bucket
  
}