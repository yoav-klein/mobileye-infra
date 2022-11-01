
output "ecs_cluster_name" {
  description = "Name of the ECS cluster created"
  value       = aws_ecs_cluster.ecs_cluster.name
}

output "ecr_repository" {
    description = "URL of the ECR repository"
    value = aws_ecr_repository.ecr_repository.repository_url
}
