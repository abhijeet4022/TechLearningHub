resource "aws_key_pair" "management_node_key" {
  key_name   = "management-node-key"
  public_key = file("${path.module}/id_rsa.pub")
}