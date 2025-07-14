variable "secret_name" {
  type        = string
  description = "Name of the secret"
}

variable "description" {
  type        = string
  description = "Description for the secret"
}

variable "secret_values" {
  type        = map(string)
  description = "Key-value pairs of secrets (e.g. username, password)"
}