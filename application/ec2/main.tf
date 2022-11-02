

resource "aws_security_group" "sg" {
  name = "containerInstanceSG"
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
  key_name   = "myKey"
  public_key = file(var.pub_key_path)
}

# ecsInstanceRole
resource "aws_iam_role" "ecs_instance_role" {
  name = "ecsInstanceRole"


  assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


resource "aws_iam_instance_profile" "instance_profile" {
  name = "ecsInstanceRole"
  role = aws_iam_role.ecs_instance_role.name
}


resource "aws_instance" "ec2_instance" {
  availability_zone    = data.aws_availability_zones.available.names[0]
  ami                  = "ami-03dbf0c122cb6cf1d" # Amazon Linux AMI
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
  key_name             = aws_key_pair.deployer.key_name
  instance_type        = "t2.medium"
  security_groups      = [aws_security_group.sg.name]


  user_data = <<-EOF
#!/bin/bash
echo "ECS_CLUSTER=${var.ecs_cluster_name}" >> /etc/ecs/ecs.config
echo "ECS_IMAGE_PULL_BEHAVIOR=always" >> /etc/ecs/ecs.config
EOF

  tags = {
    Name = "containerInstance"
  }

}


