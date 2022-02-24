output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.this.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.this.private_ip
}

output "allow_http_sg" {
  description = "security group for access instance"
  value       = aws_security_group.allow_http.id

}
