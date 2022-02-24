# Standard Variables

variable "aws_region" {
  type    = string
  default = "ap-southeast-1"
}


variable "environment" {
  description = "AWS Environment"
  type        = string
  default     = "dev"
}

variable "application" {
  type    = string
  default = "myproject"
}

# VPC Variables

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "Private subnet  - CIDR"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}
variable "public_subnets" {
  description = "Private subnet  - CIDR"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
}

# Common variable in this module

locals {
  common_tags = {
    TFModule = "VPC v1"
  }
}
