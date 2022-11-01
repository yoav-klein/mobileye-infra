

locals {
  container_name = "my-app"
  container_port = 80
}

resource "aws_ecr_repository" "ecr_repository" {
  name                 = local.container_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}


resource "aws_ecs_cluster" "ecs_cluster" {
  name = "myCluster"
}


resource "aws_ecs_task_definition" "app" {
  family = "app-task-def" # name
  container_definitions = jsonencode([
    {
      name         = local.container_name
      image        = "${aws_ecr_repository.ecr_repository.repository_url}:latest"
      cpu          = 1
      memory       = 1024
      essential    = true
      portMappings = [{ hostPort = 80, containerPort = local.container_port }]
    },
  ])
  requires_compatibilities = ["EC2"]
  cpu                      = 1024
  memory                   = 1024
  network_mode             = "bridge"
}


resource "aws_ecs_service" "ecs_service" {
  name            = "service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "EC2"
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = local.container_name
    container_port   = local.container_port
  }
}
