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


locals {
  vpc_cidr_block     = var.vpc_cidr_block
  private_cidr_block = var.private_cidr_block
  public_cidr_block  = var.public_cidr_block
  instance_type      = var.instance_type
  project_name       = var.project_name
}


// VPC + 2 Subnet

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
    "Name"        = "${local.project_name}-public",
    "Description" = "Public subnet for ${local.project_name}"
  }
}

// IGW
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name" = "IGW"
  }
}

// NAT GW + Elastic IP for NAT GW

resource "aws_eip" "nat_ip" {
}

resource "aws_nat_gateway" "main-natgw" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_net.id
  tags = {
    "Name" = "NatGW",
  }
}


// Route Tables (public + private)

resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
  tags = {
    "Name" = "public-rtb",
  }

}

resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main-natgw.id
  }
  tags = {
    "Name" = "private-rtb",
  }
}

// Route Table association
resource "aws_route_table_association" "route_public_subnet" {
  subnet_id      = aws_subnet.public_net.id
  route_table_id = aws_route_table.public-rtb.id
}

resource "aws_route_table_association" "route_private_subnet" {
  subnet_id      = aws_subnet.private_net.id
  route_table_id = aws_route_table.private-rtb.id
}

// Dynamic AMI (no a static ami id)
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

  owners = ["099720109477"] # Canonical
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

  subnet_id = aws_subnet.public_net.id

  tags = {
    Name = "private-instance"
  }
}
