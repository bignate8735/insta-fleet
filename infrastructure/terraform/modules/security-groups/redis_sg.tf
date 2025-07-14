resource "aws_security_group" "redis_sg" {
  name        = "${var.project}-redis-sg"
  description = "Allow ECS services to access Redis"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Redis access from ECS"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-redis-sg"
  }
}