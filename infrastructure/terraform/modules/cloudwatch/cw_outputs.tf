output "auth_log_group_name" {
  description = "CloudWatch Log Group for Auth Service"
  value       = aws_cloudwatch_log_group.auth_service.name
}

output "booking_log_group_name" {
  description = "CloudWatch Log Group for Booking Service"
  value       = aws_cloudwatch_log_group.booking_service.name
}

output "driver_log_group_name" {
  description = "CloudWatch Log Group for Driver Service"
  value       = aws_cloudwatch_log_group.driver_service.name
}