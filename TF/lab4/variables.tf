
variable "project_name" {
  default     = "codestar-lab4"
  type        = string
  description = "project name injected into task"
}

variable "instance_type" {
  default     = "t2.micro"
  type        = string
  description = "instance type for all EC2 instances"
}

variable "vpc_cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for VPC"
}

variable "public_cidr_block" {
  default     = "10.0.1.0/24"
  type        = string
  description = "CIDR block for public subnet"
}

variable "private_cidr_block" {
  default     = "10.0.2.0/24"
  type        = string
  description = "CIDR block for private subnet"
}
