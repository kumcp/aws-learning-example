


locals {
  instance_type = var.instance_type
  ami           = var.ami
  name          = var.project_name
}


resource "aws_instance" "myapp" {
  ami             = local.ami
  instance_type   = local.instance_type
  security_groups = [aws_security_group.allow_ssh.id]
  subnet_id       = var.subnet

  tags = {
    Name = local.name
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_demo"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_demo"
  }
}
