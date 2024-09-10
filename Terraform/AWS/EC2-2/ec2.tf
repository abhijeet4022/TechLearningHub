# Generate the SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Upload the public key to AWS
resource "aws_key_pair" "ssh_key_pair" {
  key_name   = "ssh_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  subnet_id              = aws_subnet.lab_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  key_name = aws_key_pair.ssh_key_pair.key_name

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = tls_private_key.ssh_key.private_key_pem
    host        = self.public_ip
  }

  provisioner "file" {
    source      = "helloworld.txt"
    destination = "/tmp/helloworld.txt"
  }
}