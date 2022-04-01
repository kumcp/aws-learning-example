variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "instance_name" {
  type    = string
  default = "demo-instance"
}

variable "ami" {
  type    = string
  default = "ami-055d15d9cfddf7bd3"
}

variable "common_tags" {
  type = map(any)
  default = {
    env = "staging"
  }
}
