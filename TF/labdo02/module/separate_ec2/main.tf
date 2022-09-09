


locals {
  instance_type = var.ec2_instance_type
  ami           = "ami-055d15d9cfddf7bd3"
  project_name  = var.project_name
  ssh_cidr      = var.ssh_cidr
  vpc_cidr      = "10.0.0.0/16"
  subnet_cidr   = "10.0.0.0/24"
}

resource "aws_vpc" "main_vpc" {
  cidr_block = local.vpc_cidr
  tags = {
    Name = "${local.project_name}-vpc"
  }
}

resource "aws_subnet" "main_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = local.subnet_cidr

  tags = {
    Name = "${local.project_name}-subnet"
  }
}

resource "aws_instance" "myapp" {
  ami             = local.ami
  instance_type   = local.instance_type
  security_groups = [aws_security_group.allow_ssh.id]
  subnet_id       = aws_subnet.main_subnet.id

  tags = {
    Name = local.project_name
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main_vpc.id


  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.ssh_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.project_name}-custom-ssh"
  }
}
