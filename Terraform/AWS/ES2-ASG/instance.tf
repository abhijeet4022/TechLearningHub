resource "aws_instance" "jump-server" {
  ami                    = lookup(var.AMIS, var.region)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.login-key.key_name
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]
  subnet_id              = aws_subnet.public-sub-1.id
  user_data              = file("${path.module}/script.sh")

  tags = {
    Name = "Jump-Server"
  }
}

resource "aws_ebs_volume" "sec-vol" {
  availability_zone = aws_instance.jump-server.availability_zone
  size              = 20
  type              = "gp2"
  tags = {
    Name = "Secondary-Volume"
  }
}

resource "aws_volume_attachment" "ebs_volume_attachment" {
  device_name                    = "/dev/xvdh"
  volume_id                      = aws_ebs_volume.sec-vol.id
  instance_id                    = aws_instance.jump-server.id
  stop_instance_before_detaching = true
}

output "public_ip" {
  value = aws_instance.jump-server.public_ip
}