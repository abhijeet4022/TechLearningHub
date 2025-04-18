resource "aws_instance" "web" {
  ami                    = lookup(var.AMIS, var.region)
  instance_type          = var.instance_type
  key_name               = aws_key_pair.login-key.key_name
  vpc_security_group_ids = ["${aws_security_group.sg.id}"]
  subnet_id              = aws_subnet.public-sub-2.id
  private_ip             = "10.0.11.120"
  user_data              = file("${path.module}/script.sh")
  tags = {
    Name = "webserver"
  }
}

resource "aws_ebs_volume" "ebs-volume-1" {
  availability_zone = aws_instance.web.availability_zone
  size              = 20
  type              = "gp2"
  tags = {
    Name = "ebs-volume-1"
  }
}

resource "aws_volume_attachment" "ebs-volume-1-attachment" {
  device_name                    = "/dev/xvdh"
  volume_id                      = aws_ebs_volume.ebs-volume-1.id
  instance_id                    = aws_instance.web.id
  stop_instance_before_detaching = true
}


output "public_ip" {
  value = aws_instance.web.public_ip
}

output "private_ip" {
  value = aws_instance.web.private_ip
}


output "EC2-AZ" {
  value = aws_instance.web.availability_zone

}

output "secondary-vol-id" {
  value = aws_ebs_volume.ebs-volume-1.id

}