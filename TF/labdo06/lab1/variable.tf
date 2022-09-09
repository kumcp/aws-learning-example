variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Input instance type here"
}


variable "ami" {
  type    = string
  default = "ami-055d15d9cfddf7bd3"
}


variable "project_name" {
  type = string
  #   default = "demo"
}

variable "subnet" {
  type = string
}

variable "vpc_id" {
  type = string
}
