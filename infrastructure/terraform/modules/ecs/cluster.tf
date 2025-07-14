# ---------------------------------------------
# ECS Cluster Definition (cluster.tf)
# ---------------------------------------------
resource "aws_ecs_cluster" "this" {
  name = "${var.project}-cluster"

  tags = {
    Name = "${var.project}-cluster"
  }
}

# ---------------------------------------------
# Port/Service Config (locals.tf)
# ---------------------------------------------
locals {
  services = {
    auth         = 3000
    booking      = 3001
    driver       = 3002
    dispatch     = 3003
    notification = 3004
  }
}

# ---------------------------------------------
# Auth Task Definition (auth-task.tf)
# ---------------------------------------------
resource "aws_ecs_task_definition" "auth" {
  family                   = "${var.project}-auth"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "auth"
      image     = var.auth_image
      portMappings = [{ containerPort = 3000, hostPort = 3000, protocol = "tcp" }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}/auth-service"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [{ name = "ENV", value = var.env }]
    }
  ])

  tags = { Name = "${var.project}-auth-task" }
}

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
      portMappings = [{ containerPort = 3001, hostPort = 3001, protocol = "tcp" }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}/booking-service"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [{ name = "ENV", value = var.env }]
    }
  ])

  tags = { Name = "${var.project}-booking-task" }
}

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
      portMappings = [{ containerPort = 3002, hostPort = 3002, protocol = "tcp" }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}/driver-service"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [{ name = "ENV", value = var.env }]
    }
  ])

  tags = { Name = "${var.project}-driver-task" }
}

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