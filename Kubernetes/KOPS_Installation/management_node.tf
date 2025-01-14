# Create the management node for kubernetes cluster
resource "aws_instance" "management_node" {
  # Without depends_on destroy will fail due to destroy time provisioner
  depends_on = [
    aws_s3_bucket.bucket,
    aws_iam_role_policy_attachment.admin_policy_attachment,
    aws_security_group.allow_all,
    aws_security_group_rule.inbound_allow_all,
    aws_security_group_rule.outbound_allow_all,
    aws_iam_instance_profile.admin_instance_profile
  ]

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

  # Provisioner for running commands before destruction
  provisioner "remote-exec" {
    when = destroy
    inline = [
      "bash -c 'source /etc/profile && kops delete cluster --name $CLUSTER_NAME --yes || true'",
    ]

    connection {
      type        = "ssh"
      host        = self.private_ip
      user        = "ubuntu" # Adjust based on your AMI
      private_key = file("${path.module}/id_rsa")
    }
  }

}

output "Message" {
  value = "Login to the Management Node - ssh -i id_rsa ubuntu@${aws_instance.management_node.private_ip}"
}