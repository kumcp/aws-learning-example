variable "project_name" {
  default     = "codestar-lab4"
  type        = string
  description = "Project name injected into task"
}

variable "ami" {
  default     = "ami-055d15d9cfddf7bd3"
  type        = string
  description = "ami id for creating ec2 instance"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "instance type for creatinf ec2 instance"
}

variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for vpc"
}

variable "public_cidr_block" {
  default     = "10.0.0.0/24"
  type        = string
  description = "CIDR block for public subnet"
}

variable "private_cidr_block" {
  default     = "10.0.0.0/24"
  type        = string
  description = "CIDR block for private subnet"
}