# Create the Key-Pair
resource "aws_key_pair" "key-tf" {
  key_name   = "nv-key-tf"
  public_key = file("${path.module}/id_rsa.pub") #It will print the file content. "id_rsa.pub" path.module it will
  # consider current directory.
}

output "keyname" {
  value = aws_key_pair.key-tf.key_name

}
