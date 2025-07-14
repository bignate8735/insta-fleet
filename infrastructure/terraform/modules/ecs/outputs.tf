output "cluster_id" {
  value       = aws_ecs_cluster.this.id
  description = "ECS Cluster ID"
}

output "service_names" {
  value = {
    for service, res in aws_ecs_service.services :
    service => res.name
  }
  description = "Names of ECS Services"
}