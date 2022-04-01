terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
}


resource "aws_instance" "myapp" {
  ami           = "ami-055d15d9cfddf7bd3"
  instance_type = "t2.micro"


  tags = {
    Name = "${var.instance_name}"
  }
}


output "ip_public" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.myapp[*].public_ip
}

output "ip_private" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.myapp.private_ip
}
