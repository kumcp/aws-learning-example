output "public_ip" {
  description = "ID of the public EC2 instance"
  value       = aws_instance.public_instance.public_ip
}

