variable "ec2_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "ec2 instance type"
}

variable "ssh_cidr" {
  type        = string
  default     = "0.0.0.0/0"
  description = "ssh cidr"
}

variable "project_name" {
  type        = string
  default     = "demo-lab"
  description = "project name"
}
