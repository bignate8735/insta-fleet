# ------------------------------------------------------------------------------
# Outputs for S3 uploads bucket
# ------------------------------------------------------------------------------
output "uploads_bucket_name" {
  description = "Name of the S3 uploads bucket"
  value       = aws_s3_bucket.uploads.bucket
}

output "uploads_bucket_arn" {
  description = "ARN of the S3 uploads bucket"
  value       = aws_s3_bucket.uploads.arn
}