
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


resource "aws_security_group" "sg" {
  name = "jenkinsSG"
  # vpc - defaults to the deafult vpc

  ingress {
    description = "ssh connectivity"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_key_pair" "deployer" {
  key_name   = "jenkinsKey"
  public_key = file("${path.module}/key.pub")
}

resource "aws_instance" "ec2_instance" {
  availability_zone    = data.aws_availability_zones.available.names[0]
  ami                  = "ami-08c40ec9ead489470" # Ubuntu
  key_name             = aws_key_pair.deployer.key_name
  instance_type        = "t2.small"
  security_groups      = [aws_security_group.sg.name]

  tags = {
    Name = "jenkins"
  }

}


