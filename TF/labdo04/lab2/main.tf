locals {
  allow_port    = var.allow_port_access
  instance_type = var.instance_type
}

resource "aws_instance" "web" {
  ami             = "ami-04d9e855d716f9c99" # data.aws_ami.ubuntu.id
  instance_type   = local.instance_type
  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "HelloWorld"
  }
}

data "aws_vpc" "default_vpc" {
  default = true
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = local.allow_port
    to_port     = local.allow_port
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default_vpc.cidr_block]
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
