# =========================
# envs/dev/variables.tf & envs/prod/variables.tf
# =========================
variable "vpc_cidr" {}
variable "instance_type" {}
variable "key_name" {}
variable "db_username" {}
variable "db_password" {}


variable "project" {
  type        = string
  description = "Project name"
}

variable "env" {
  type        = string
  description = "Environment (dev, prod)"
}

variable "db_username" {
  type        = string
  description = "DB Username"
}

variable "db_password" {
  type        = string
  description = "DB Password"
}