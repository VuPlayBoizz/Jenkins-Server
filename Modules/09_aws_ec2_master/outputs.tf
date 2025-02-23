output "master_public_ip" {
    value = aws_instance.ec2_instance.public_ip
}
output "master_private_ip" {
    value = aws_instance.ec2_instance.private_ip
}
