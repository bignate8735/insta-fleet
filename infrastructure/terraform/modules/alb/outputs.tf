output "alb_dns_name" {
  description = "Public DNS of the ALB"
  value       = aws_lb.this.dns_name
}

output "auth_target_group_arn" {
  value       = aws_lb_target_group.services["auth"].arn
  description = "Target group ARN for auth service"
}

output "booking_target_group_arn" {
  value       = aws_lb_target_group.services["booking"].arn
  description = "Target group ARN for booking service"
}

output "driver_target_group_arn" {
  value       = aws_lb_target_group.services["driver"].arn
  description = "Target group ARN for driver service"
}

output "dispatch_target_group_arn" {
  value       = aws_lb_target_group.services["dispatch"].arn
  description = "Target group ARN for dispatch service"
}

output "notification_target_group_arn" {
  value       = aws_lb_target_group.services["notification"].arn
  description = "Target group ARN for notification service"
}