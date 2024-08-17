resource "aws_key_pair" "key-name" {
  key_name   = "web-key"
  public_key = file("${path.module}/mykey.pub")
}