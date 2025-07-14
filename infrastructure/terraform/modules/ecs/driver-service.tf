# ---------------------------------------------
# Driver Service Definition (driver-service.tf)
# ---------------------------------------------
resource "aws_ecs_service" "driver" {
  name            = "${var.project}-driver-service"
  cluster         = aws_ecs_cluster.this.id
  launch_type     = "FARGATE"
  desired_count   = 2
  task_definition = aws_ecs_task_definition.driver.arn

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.driver_target_group_arn
    container_name   = "driver"
    container_port   = 3002
  }

  tags = { Name = "${var.project}-driver-service" }
}
