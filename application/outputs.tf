
output "ecr_repository" {
    description = "URL of the ECR repository"
    value = module.ecs.ecr_repository
}
