resource "aws_key_pair" "key_pair" {
  key_name   = "terraform-key"
  public_key = file("${path.module}/mykey.pub")
}

output "key_name" {
  value = aws_key_pair.key_pair.key_name
}