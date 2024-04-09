output "webserver-security_group_id" {
  value = aws_security_group.sg.id
}

output "RDS-security_group_id" {
  value = aws_security_group.allow-mariadb.id
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

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "rds-endpoint" {
  value = aws_db_instance.mariadb.endpoint
}