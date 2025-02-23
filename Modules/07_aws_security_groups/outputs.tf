output "public_security_group_id" {
    value = aws_security_group.public-sg.id
}
output "private_security_group_id" {
    value = aws_security_group.private-sg.id
}