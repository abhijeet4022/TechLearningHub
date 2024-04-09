data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  # AMI_Name = ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-20230516
  # root_device_type = ebs
  # Virtualization type = HVM

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}


# Create Instance
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key-tf.key_name
  vpc_security_group_ids = ["${aws_security_group.webserver.id}"]
  tags = {
    Name = "WebServer"
  }
  user_data = file("${path.module}/script.sh")

  # File, Local-Exec, Remote-Exec.
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/id_rsa")
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "readme.md"      # Terraform machine file
    destination = "/tmp/readme.md" # Remote machine location ex. EC2

  }
  # We can use content also like source.
  provisioner "file" {
    on_failure  = continue
    content     = "This is test content" # Terraform machine file
    destination = "/tmp/content.md"      # Remote machine location ex. EC2

  }

}