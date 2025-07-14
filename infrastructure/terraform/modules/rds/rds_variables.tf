variable "project" {
  description = "Project or environment prefix"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where RDS resides"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for RDS"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "Security group ID of ECS (used to allow access)"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Master username for the DB"
  type        = string
}

variable "db_password" {
  description = "Master password for the DB"
  type        = string
  sensitive   = true
}

variable "mysql_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0.35"
}

variable "ecs_task_role_name" {
  description = "ECS task role name (not ARN)"
  type        = string
}