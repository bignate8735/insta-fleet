# ------------------------------------------------------------------------------
# CloudWatch Dashboard for ECS Services (CPU and Memory)
# ------------------------------------------------------------------------------

resource "aws_cloudwatch_dashboard" "ecs_services" {
  dashboard_name = "${var.project}-ecs-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        "type" : "metric",
        "x" : 0,
        "y" : 0,
        "width" : 12,
        "height" : 6,
        "properties" : {
          "title" : "Auth Service CPU",
          "metrics" : [
            [ "AWS/ECS", "CPUUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", "${var.project}-auth-service" ]
          ],
          "stat" : "Average",
          "period" : 60,
          "region" : var.aws_region
        }
      },
      {
        "type" : "metric",
        "x" : 12,
        "y" : 0,
        "width" : 12,
        "height" : 6,
        "properties" : {
          "title" : "Auth Service Memory",
          "metrics" : [
            [ "AWS/ECS", "MemoryUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", "${var.project}-auth-service" ]
          ],
          "stat" : "Average",
          "period" : 60,
          "region" : var.aws_region
        }
      }
    ]
  })
}