# ------------------------------
# alb_outputs.tf
# ------------------------------
output "alb_dns_name" {
  description = "Public DNS of the ALB"
  value       = aws_lb.this.dns_name
}

output "target_group_arns" {
  description = "Map of service to Target Group ARNs"
  value = {
    for service, tg in aws_lb_target_group.services :
    service => tg.arn
  }
}