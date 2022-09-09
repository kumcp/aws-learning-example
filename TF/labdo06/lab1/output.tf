output "public_ip" {
  value = aws_instance.myapp.public_ip
}

output "private_ip" {
  value = aws_instance.myapp.private_ip
}
