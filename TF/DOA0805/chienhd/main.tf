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
  region = "ap-southeast-1"
}

locals {
  ami                = var.ami
  instance_type      = var.instance_type
  project_name       = var.project_name
  vpc_cidr_block     = var.vpc_cidr_block
  private_cidr_block = var.private_cidr_block
  public_cidr_block  = var.public_cidr_block
}

resource "aws_instance" "myapp" {
  ami           = local.ami
  instance_type = local.instance_type

  tags = {
    Name = local.project_name
  }

  security_groups = [aws_security_group.allow_http]
}


resource "aws_security_group" "allow_http" {
  name        = "allow-ssh-lab2"
  description = "Allow SSH inbound traffic"

  ingress = {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress = {
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = local.vpc_cidr_block
  tags = {
    "Name"        = "${local.project_name}-vpc",
    "Description" = "VPC"
  }
}

resource "aws_subnet" "private_net" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = local.private_cidr_block

  tags = {
    "Name"        = "${local.project_name}-private",
    "Description" = "Private subnet for ${local.project_name}"
  }
}


resource "aws_subnet" "public_net" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = local.public_cidr_block

  tags = {
    "Name"        = "${local.project_name}-private",
    "Description" = "Public subnet for ${local.project_name}"
  }
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "IGW"
  }
}

resource "aws_eip" "nat_ip" {

}

resource "aws_nat_gateway" "main-natgw" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_net.id
  tags = {
    "Name" = "NatGw",
  }
}

resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    "Name" = "public-rtb"
  }
}


resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    "Name" = "private-rtb"
  }
}

resource "aws_route_table_association" "route_public_subnet" {
  subnet_id      = aws_subnet.public_net.id
  route_table_id = aws_route_table.public-rtb.id

}

resource "aws_route_table_association" "route_private_subnet" {
  subnet_id      = aws_subnet.public_net.id
  route_table_id = aws_route_table.private-rtb.id

}


data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

resource "aws_instance" "public_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = local.instance_type
  subnet_id                   = aws_subnet.public_net.id
  associate_public_ip_address = "true"
  tags = {
    Name = "public-instance"
  }
}

resource "aws_instance" "private_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type
  subnet_id     = aws_subnet.public_net.id
  tags = {
    Name = "private-instance"
  }
}