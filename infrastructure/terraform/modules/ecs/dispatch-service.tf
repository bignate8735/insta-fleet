# ---------------------------------------------
# Dispatch Service Definition (dispatch-service.tf)
# ---------------------------------------------
resource "aws_ecs_service" "dispatch" {
  name            = "${var.project}-dispatch-service"
  cluster         = aws_ecs_cluster.this.id
  launch_type     = "FARGATE"
  desired_count   = 2
  task_definition = aws_ecs_task_definition.dispatch.arn

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.dispatch_target_group_arn
    container_name   = "dispatch"
    container_port   = 3003
  }

  tags = { Name = "${var.project}-dispatch-service" }
}
