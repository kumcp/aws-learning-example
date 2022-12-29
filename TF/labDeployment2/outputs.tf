output "public_ip" {
  description = "ID of the instance"
  value       = aws_instance.main.public_ip
}
