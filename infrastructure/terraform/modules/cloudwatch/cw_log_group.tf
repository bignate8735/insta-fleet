# ------------------------------------------------------------------------------
# CloudWatch Log Groups for ECS Services with Encryption and Extended Retention
# ------------------------------------------------------------------------------

resource "aws_cloudwatch_log_group" "auth_service" {
  name              = "/ecs/${var.project}/auth-service"
  retention_in_days = 30
  kms_key_id        = "alias/aws/logs"  # AWS-managed KMS key
  tags = {
    Name = "auth-service-logs"
  }
}

resource "aws_cloudwatch_log_group" "booking_service" {
  name              = "/ecs/${var.project}/booking-service"
  retention_in_days = 30
  kms_key_id        = "alias/aws/logs"
  tags = {
    Name = "booking-service-logs"
  }
}

resource "aws_cloudwatch_log_group" "driver_service" {
  name              = "/ecs/${var.project}/driver-service"
  retention_in_days = 30
  kms_key_id        = "alias/aws/logs"
  tags = {
    Name = "driver-service-logs"
  }
}