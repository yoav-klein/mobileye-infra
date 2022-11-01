
output "public_dns" {
    description = "Public DNS of the instance"
    value = aws_instance.ec2_instance.public_dns
}
