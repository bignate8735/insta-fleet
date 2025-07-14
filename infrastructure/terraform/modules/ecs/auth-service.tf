# ---------------------------------------------
# Auth Service Definition (auth-service.tf)
# ---------------------------------------------
resource "aws_ecs_service" "auth" {
  name            = "${var.project}-auth-service"
  cluster         = aws_ecs_cluster.this.id
  launch_type     = "FARGATE"
  desired_count   = 2
  task_definition = aws_ecs_task_definition.auth.arn

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.auth_target_group_arn
    container_name   = "auth"
    container_port   = 3000
  }

  tags = { Name = "${var.project}-auth-service" }
}