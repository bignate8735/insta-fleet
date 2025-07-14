# ------------------------------------------------------------------------------
# CloudWatch CPU Alarm for ECS Services (example for auth-service)
# ------------------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "auth_high_cpu" {
  alarm_name          = "${var.project}-auth-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 75

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = "${var.project}-auth-service"
  }

  alarm_description = "Triggered when auth-service CPU exceeds 75% for 2 minutes"
  actions_enabled   = true

  tags = {
    Name = "auth-service-cpu-alarm"
  }
}