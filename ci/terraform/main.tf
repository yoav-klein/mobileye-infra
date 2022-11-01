
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDyFizoH/zu75qix7Z56+PuBBEUMYnPzBTLPL2hjimx3c9qeU+S/+SC1R9m/tpYeTZnY8LYc3tZzXmIWOhQoAx557zBnC21KD20waI+AvR2hI5lIgV9T7krSEV0NQ36drmZUvBeEuF3p4bRK5ywZei59UqkkIcMReyl0ZHX7fuqMapOiXanjzivigstLqtwus+xR16KhpKQx34azSk+S4lb2uK/KT4um1wENTDSyey1EPUM3phSXa39qY3zgwbT/sSWInXguAfvI4r9/xsLd04seUviQEhWwJ5EnAzMjhhc/xvEuWauKTicaY7Hgq/OdhNEc7Tua8qFgJsgRTW5tMWUELYQn26JwSVoN9WFVNSUUATzV50G21ykwx6MbYkxZvQWUs5Zq5KP+Gr/h0g3a/gU6hBxu+XsOT2AhIs6UGbm8JMNfc1HKR0/WbBM+bjsebFVkB6hk/1avbDU61XZ458wLSkUpvjxGiYl67Bld2lbDaPzFzcv5VTNyNbwZe9Zunk= yoav@yoav-VirtualBox"
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


