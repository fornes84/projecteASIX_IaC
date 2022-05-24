
// POLITIQUES DE ESCALADA UP !!! (QUAN ES DISPARA L'AlARMA FA AIXÒ)

resource "aws_autoscaling_policy" "web_policy_up" {  //OK !!!
  name                   = "web_policy_up"   // quin nom ?
  //scaling_adjustment     = 1                            // escalar de una en una
  adjustment_type        = "ChangeInCapacity"
  estimated_instance_warmup = 120                        // en 120 seg, ja mirara la CPU per fer mitja, de la instancia aixecada 
  autoscaling_group_name = aws_autoscaling_group.group_autoscal.name
  policy_type            = "TargetTrackingScaling"       //per defecte es SimpleScaling pero no se si es el que volem

  // SI POSEM RESPECTE ADALT policy_type            = TargetTrackingScaling  AFEGIM EL D'ABAIX

  target_tracking_configuration {
  predefined_metric_specification {
    predefined_metric_type = "ASGAverageCPUUtilization"
  }
  target_value = 60.0
  }

}

// TIPUS D'ALARMA (CONTROL % CPU)

resource "aws_cloudwatch_metric_alarm" "web_server_ALARM_up" {  //no se la dif entre noms !!
  alarm_name          = "web_server_CPU_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"  
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"              // hi habia 120
  statistic           = "Average"
  threshold           = "60"              //valor

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.group_autoscal.name

  }
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.web_policy_up.arn}"]  //segur ha de ser un arn
  actions_enabled = true
  
}

// POLITIQUES DE ESCALADA DOWN !!!! 

resource "aws_autoscaling_policy" "web_policy_down" {
  name                   = "web_policy_down"   // quin nom ?
  scaling_adjustment     = -1                            // escalar de una en una
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 120                         // en 120 seg, ja mirara la CPU per fer mitja, de la instancia aixecada 
  autoscaling_group_name = aws_autoscaling_group.group_autoscal.name
  
}

// TIPUS D'ALARMA (CONTROL % CPU)

resource "aws_cloudwatch_metric_alarm" "web_server_ALARM_down" {  //no se la dif entre noms !!
  alarm_name          = "web_server_CPU_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"  
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"              // hi habia 120
  statistic           = "Average"
  threshold           = "10"              //valor

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.group_autoscal.name

  }
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.web_policy_down.arn}"]  //crec
}