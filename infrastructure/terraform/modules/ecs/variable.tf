variable "project" {
  description = "Project name"
  type        = string
}

variable "env" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

# ECS IAM Roles
variable "execution_role_arn" {
  description = "IAM Role ARN for ECS execution"
  type        = string
}

variable "task_role_arn" {
  description = "IAM Role ARN for ECS task"
  type        = string
}

# Networking
variable "private_subnet_ids" {
  description = "List of private subnets for ECS"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "Security Group for ECS tasks"
  type        = string
}

variable "db_secret_arn" {
  description = "ARN of the Secrets Manager secret storing DB credentials"
  type        = string
}


# Container Images
variable "auth_image" { type = string }
variable "booking_image" { type = string }
variable "driver_image" { type = string }
variable "dispatch_image" { type = string }
variable "notification_image" { type = string }

# ALB Target Groups
variable "auth_target_group_arn" { type = string }
variable "booking_target_group_arn" { type = string }
variable "driver_target_group_arn" { type = string }
variable "dispatch_target_group_arn" { type = string }
variable "notification_target_group_arn" { type = string }

