resource "aws_instance" "web" {
  ami                    = lookup(var.AMIS, var.region)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key-name.key_name
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]
  #user_data              = file("${path.module}/script.sh")


  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.module}/mykey")
    host        = self.public_ip
  }


  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.web.private_ip} > private-ip.txt"

  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh",
    ]

  }

  tags = {
    Name = "WebServer"
  }
}

output "public_ip" {
  value = aws_instance.web.public_ip
}