variable "project" {
  description = "Project name for naming resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to associate with SGs"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to SSH into EC2 (e.g., your IP)"
  type        = string
}

variable "ecs_sg_id" {
  description = "ID of the ECS security group (used for RDS/Redis access)"
  type        = string
}