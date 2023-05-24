output "instance_id" {
  description = "ID of the ec2 instance"
  value       = aws_instance.myapp.id
}

output "instance_ip" {
  dedescription = "public ip of instance"
  value         = aws_instance.myapp.public_ip
}

output "public_ip" {
  description = "ID of the public ec2 instance"
  value       = aws_instance.public_instance.public_ip
}