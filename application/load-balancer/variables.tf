
variable "vpc_id" {
  type        = string
  description = "VPC ID to place the load balancer in"
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet IDs to create load balancer nodes in"
}
