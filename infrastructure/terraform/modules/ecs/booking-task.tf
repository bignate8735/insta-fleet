# ---------------------------------------------
# Booking Task Definition (booking-task.tf)
# ---------------------------------------------
resource "aws_ecs_task_definition" "booking" {
  family                   = "${var.project}-booking"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "booking"
      image     = var.booking_image
      portMappings = [{
        containerPort = 3001,
        hostPort      = 3001,
        protocol      = "tcp"
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}/booking-service"
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
    Name = "${var.project}-booking-task"
  }
}