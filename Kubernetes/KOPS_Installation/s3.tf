# S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket           = "cluster.learntechnology.cloud" # Replace with a globally unique name
  tags             = { Name = "ExampleBucket" }
  force_destroy    = true  # Automatically delete objects when destroying the bucket
}

# Optional: Enable Versioning
resource "aws_s3_bucket_versioning" "example_bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}