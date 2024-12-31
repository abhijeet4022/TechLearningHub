# S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket           = "learntechnology.cloud" # Replace with a globally unique name
  tags             = { Name = "ExampleBucket" }
  object_ownership = "BucketOwnerEnforced"

}

# Optional: Enable Versioning
resource "aws_s3_bucket_versioning" "example_bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}