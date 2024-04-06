resource "aws_instance" "instance" {
  ami                    = data.aws_ami.ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group
  tags                   = {
    Name    = var.name
    Project = var.project
  }
}

resource "aws_route53_record" "records" {
  zone_id = var.zone_id
  name    = "${var.name}-dev.learntechnology.cloud"
  type    = "A"
  ttl     = 10
  records = [aws_instance.instance.private_ip]
}

resource "null_resource" "ansible" {
  depends_on = [
    aws_route53_record.records
  ]

  provisioner "local-exec" {
    command = <<EOF
cd /home/centos/TechLearningHub/DevOps/ECommerce-Project/Ansible-RoboShop
git pull
sleep 90
ansible-playbook -i ${var.name}-dev.learntechnology.cloud, main.yml -e ansible_user=centos -e ansible_password=DevOps321 -e component=${var.name}
EOF
}
}
