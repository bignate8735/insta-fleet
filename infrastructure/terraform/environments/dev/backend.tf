# =========================
# envs/dev/backend.tf & envs/prod/backend.tf
# =========================
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "envs/dev/terraform.tfstate"  # Change to prod in prod env
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
