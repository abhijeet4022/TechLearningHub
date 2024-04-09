resource "aws_instance" "terra" {
  ami                    = lookup(var.AMIS, var.region)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]
  # role:
  iam_instance_profile = aws_iam_instance_profile.s3-bucket-role-instanceprofile.name

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
    command = "echo  ${aws_instance.terra.private_ip} > private_ip.txt"

  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh",
    ]

  }

  tags = {
    Name = "terraform-machine"
  }
}

output "public_ip" {
  value = aws_instance.terra.public_ip

}

