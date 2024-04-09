# scale up alarm

resource "aws_autoscaling_policy" "scale_out_policy" {
  name                   = "scale_out_policy"
  autoscaling_group_name = aws_autoscaling_group.web-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "60"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "high_cpu_alarm" {
  alarm_name          = "high-cpu-alarm-more-than-70%"
  alarm_description   = "cpu-utilization-more-than-70%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.web-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_out_policy.arn]
}

# scale down alarm
resource "aws_autoscaling_policy" "scale_in_policy" {
  name                   = "scale_in_policy"
  autoscaling_group_name = aws_autoscaling_group.web-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "60"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "scale-in" {
  alarm_name          = "low_cpu_alarm-less-than-40%"
  alarm_description   = "low_cpu_alarm-less-than-40%"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "40"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.web-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_in_policy.arn]
}

