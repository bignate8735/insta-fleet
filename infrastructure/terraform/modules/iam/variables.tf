variable "project" {
  description = "Project or environment name prefix"
  type        = string
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "ecs_task_role_name" {
  type        = string
  description = "Name of the ECS task role to attach this policy to"
}

variable "dispatch_queue_arn" {
  type        = string
  description = "ARN of the dispatch queue"
}

variable "notification_queue_arn" {
  type        = string
  description = "ARN of the notification queue"
}