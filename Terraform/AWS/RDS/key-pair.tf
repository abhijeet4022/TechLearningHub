# Creating key pair
resource "aws_key_pair" "login-key" {
  key_name   = "ssh-key"
  public_key = file("${path.module}/login-key.pub")
  tags = {
    Name = "login-key"
  }
}

output "Key-Name" {
  value = aws_key_pair.login-key.key_name
}