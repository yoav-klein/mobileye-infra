
output "target_group_arn" {
  value       = module.alb.target_group_arns[0]
  description = "ARN of target group created"
}
