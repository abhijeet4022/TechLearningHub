resource "local_file" "foo" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "key.pem"
  file_permission = "0400"
}

output "public_ip" {
  value = aws_instance.web.public_ip
}