resource "aws_launch_configuration" "web-launchconfig" {
  name_prefix       = "web-launchconfig"
  image_id          = lookup(var.AMIS, var.region)
  instance_type     = "t2.micro"
  key_name          = aws_key_pair.login-key.key_name
  security_groups   = [aws_security_group.sg.id]
  user_data         = file("${path.module}/script.sh")
  enable_monitoring = true
}

resource "aws_autoscaling_group" "web-autoscaling" {
  name                      = "web-autoscaling"
  vpc_zone_identifier       = [aws_subnet.private-sub-1.id, aws_subnet.private-sub-2.id]
  launch_configuration      = aws_launch_configuration.web-launchconfig.name
  min_size                  = 3
  max_size                  = 6
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "ec2-instance"
    propagate_at_launch = true
  }
}
