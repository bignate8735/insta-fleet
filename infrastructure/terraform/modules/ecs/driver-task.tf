# ---------------------------------------------
# Driver Task Definition (driver-task.tf)
# ---------------------------------------------
resource "aws_ecs_task_definition" "driver" {
  family                   = "${var.project}-driver"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "driver"
      image     = var.driver_image
      portMappings = [{
        containerPort = 3002,
        hostPort      = 3002,
        protocol      = "tcp"
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}/driver-service"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        { name = "ENV", value = var.env }
      ]
      secrets = [
        {
          name      = "DB_USERNAME"
          valueFrom = "${var.db_secret_arn}:username::"
        },
        {
          name      = "DB_PASSWORD"
          valueFrom = "${var.db_secret_arn}:password::"
        }
      ]
    }
  ])

  tags = {
    Name = "${var.project}-driver-task"
  }
}