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

test_map = {
 test1 = "test2",
 test2 = "test4"
}

resource "aws_instance" "myapp" {
  ami           = "ami-055d15d9cfddf7bd3"
  instance_type = "t2.micro"
  for_each      = tomap(["1" = "a", "2" = "b"])

  tags = {
    Name = "${var.instance_name}-${each.key}"
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
