
variable "project_name" {
  default     = "codestar-lab3"
  type        = string
  description = "project name injected into task"
}

variable "ami" {
  default     = "ami-055d15d9cfddf7bd3"
  type        = string
  description = "ami id for creating Ec2 instance"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "instance type for creating EC2 instance"

}
