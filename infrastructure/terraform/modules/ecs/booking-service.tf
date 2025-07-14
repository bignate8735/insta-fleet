# ---------------------------------------------
# Booking Service Definition (booking-service.tf)
# ---------------------------------------------
resource "aws_ecs_service" "booking" {
  name            = "${var.project}-booking-service"
  cluster         = aws_ecs_cluster.this.id
  launch_type     = "FARGATE"
  desired_count   = 2
  task_definition = aws_ecs_task_definition.booking.arn

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.booking_target_group_arn
    container_name   = "booking"
    container_port   = 3001
  }

  tags = { Name = "${var.project}-booking-service" }
}
