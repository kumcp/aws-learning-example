
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


locals {
  region             = "ap-southeast-1"
  vpc_cidr_block     = "10.0.0.0/16"
  subnets_cidr_block = "10.0.1.0/24"

  instance_type = "t2.micro"
  common_tags = {
    source  = "terraform"
    project = "codestar-system"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = local.vpc_cidr_block

  # This lab use only region a for simplicity. You can write this code to be more verbose (like get all AZs in region)
  azs            = ["${local.region}a"]
  public_subnets = ["${local.subnets_cidr_block}"]

  tags = local.common_tags
}


// Search for AMI ubuntu 20.04
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


resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh-lab-system"
  description = "Allow SSH inbound traffic"

  ingress { // inbound
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { // outbound
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = local.common_tags
}

resource "aws_security_group" "allow_test_port" {
  name        = "allow-test-port-lab-system"
  description = "Allow Port 3000 inbound traffic"

  ingress { // inbound
    description = "Allow SSH"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type


  security_groups = [aws_security_group.allow_ssh.name, aws_security_group.allow_test_port.name]

  tags = local.common_tags

  user_data = templatefile("./script/userdata.sh", {})
}

