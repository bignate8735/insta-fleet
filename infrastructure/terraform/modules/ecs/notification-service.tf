# ---------------------------------------------
# Notification Service Definition (notification-service.tf)
# ---------------------------------------------
resource "aws_ecs_service" "notification" {
  name            = "${var.project}-notification-service"
  cluster         = aws_ecs_cluster.this.id
  launch_type     = "FARGATE"
  desired_count   = 2
  task_definition = aws_ecs_task_definition.notification.arn

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.notification_target_group_arn
    container_name   = "notification"
    container_port   = 3004
  }

  tags = { Name = "${var.project}-notification-service" }
}