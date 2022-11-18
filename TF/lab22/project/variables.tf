
variable "project_name" {
  type        = string
  default     = "lab22"
  description = "Name of the project"
}


variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type"
}
