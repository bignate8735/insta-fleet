# ------------------------------
# alb_variables.tf
# ------------------------------
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

variable "ssl_certificate_arn" {
  description = "ACM SSL certificate ARN for HTTPS"
  type        = string
}

variable "alb_log_bucket" {
  description = "S3 bucket name for storing ALB logs"
  type        = string
}