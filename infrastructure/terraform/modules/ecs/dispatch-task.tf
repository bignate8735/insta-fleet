# ---------------------------------------------
# Dispatch Task Definition (dispatch-task.tf)
# ---------------------------------------------
resource "aws_ecs_task_definition" "dispatch" {
  family                   = "${var.project}-dispatch"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "dispatch"
      image     = var.dispatch_image
      portMappings = [{ containerPort = 3003, hostPort = 3003, protocol = "tcp" }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}/dispatch-service"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [{ name = "ENV", value = var.env }]
    }
  ])

  tags = { Name = "${var.project}-dispatch-task" }
}
