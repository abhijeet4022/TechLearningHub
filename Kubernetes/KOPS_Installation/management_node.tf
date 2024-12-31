resource "aws_instance" "management_node" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.management_node_key.key_name
  availability_zone           = "us-east-1a"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  user_data                   = file("${path.module}/userdata.sh")
  iam_instance_profile        = aws_iam_instance_profile.admin_instance_profile.name
  disable_api_termination     = true

  ebs_block_device {
    device_name           = "/dev/sda1"
    volume_size           = 10
    delete_on_termination = true
    tags                  = { Name = "management_node-os-disk" }
  }

  tags = {
    Name = "management_node"
  }
}

output "management_node_public_ip" {
  value = "management_node public_ip is - ${aws_instance.management_node.public_ip}"
}