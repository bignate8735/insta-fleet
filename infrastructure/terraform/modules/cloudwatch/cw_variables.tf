variable "project" {
  description = "Project name prefix for resources"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster (used for alarm dimensions)"
  type        = string
}

variable "aws_region" {
  description = "AWS region for metrics and dashboards"
  type        = string
}