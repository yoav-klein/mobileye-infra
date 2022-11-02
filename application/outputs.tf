
output "ecr_repository" {
    description = "URL of the ECR repository"
    value = module.ecs.ecr_repository
}

output "load_balancer_dns" {
    description = "DNS name of load balancer"
    value = module.alb.dns_name
}
