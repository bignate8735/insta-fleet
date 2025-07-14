# ------------------------------------------------------------------------------
# Input variables for S3 uploads bucket
# ------------------------------------------------------------------------------
variable "project" {
  description = "Project name prefix"
  type        = string
}

variable "env" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}