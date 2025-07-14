# ------------------------------------------------------------------------------
# Lifecycle rule to expire old noncurrent versions after 30 days
# ------------------------------------------------------------------------------
resource "aws_s3_bucket_lifecycle_configuration" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  rule {
    id     = "expire-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
     days = 30
    }
  }
}