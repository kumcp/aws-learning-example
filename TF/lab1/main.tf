terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.9.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
}


resource "aws_instance" "myapp" {
  ami           = "ami-055d15d9cfddf7bd3"
  instance_type = "t2.micro"


  tags = {
    Name = "demo-lab1"
  }
}
