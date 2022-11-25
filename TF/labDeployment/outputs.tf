output "public_ip" {
  description = "ID of the instance"
  value       = aws_instance.main.public_ip
}

output "db_host" {
  description = "Domain of DB"
  value       = aws_db_instance.main_db.domain
}
