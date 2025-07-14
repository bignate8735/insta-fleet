# ------------------------------------------------------------------------------
# Create the main S3 bucket for file uploads (e.g., receipts, profiles)
# ------------------------------------------------------------------------------
resource "aws_s3_bucket" "uploads" {
  bucket        = "${var.project}-uploads-${var.env}"
  force_destroy = true

  tags = {
    Name        = "${var.project}-uploads"
    Environment = var.env
  }
}