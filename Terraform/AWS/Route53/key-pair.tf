resource "aws_key_pair" "login-key" {
  key_name   = "web-login"
  public_key = file("${path.module}/mykey.pub")
}

output "key-name" {
  value = aws_key_pair.login-key.key_name
}