
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
    region = "us-east-1"    
}

# data sources to get VPC and subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

module "ecs" {
  source           = "./ecs"
  target_group_arn = module.alb.target_group_arn
}

module "ec2" {
  source           = "./ec2"
  ecs_cluster_name = module.ecs.ecs_cluster_name
  pub_key_path = "${path.root}/key.pub"
}

module "alb" {
  source  = "./load-balancer"
  vpc_id  = data.aws_vpc.default.id
  subnets = data.aws_subnets.all.ids
}
