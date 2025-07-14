output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "redis_sg_id" {
  description = "Security Group ID for Redis"
  value       = aws_security_group.redis_sg.id
}

output "ssh_sg_id" {
  description = "Security Group ID for SSH/Bastion"
  value       = aws_security_group.ssh_sg.id
}