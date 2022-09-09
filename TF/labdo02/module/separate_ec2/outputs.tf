output "ec2_public_ip" {
  value = aws_instance.myapp.public_ip
}

output "ec2_private_ip" {
  value = aws_instance.myapp.private_ip
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}
