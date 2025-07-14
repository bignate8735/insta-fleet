# ---------------------------------------------
# Notification Task Definition (notification-task.tf)
# ---------------------------------------------
resource "aws_ecs_task_definition" "notification" {
  family                   = "${var.project}-notification"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "notification"
      image     = var.notification_image
      portMappings = [{ containerPort = 3004, hostPort = 3004, protocol = "tcp" }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}/notification-service"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [{ name = "ENV", value = var.env }]
    }
  ])

  tags = { Name = "${var.project}-notification-task" }
}