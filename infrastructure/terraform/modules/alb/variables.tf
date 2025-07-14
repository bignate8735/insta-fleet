variable "project" {
  description = "Project name (used in naming resources)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for ALB target groups"
  type        = string
}

variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnets for the ALB"
  type        = list(string)
}