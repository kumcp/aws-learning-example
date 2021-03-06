terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.72.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_instance" "myapp" {
  ami           = "ami-055d15d9cfddf7bd3"
  instance_type = "t2.micro"

  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    name = var.instance_name
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh2"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allow_ssh]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
