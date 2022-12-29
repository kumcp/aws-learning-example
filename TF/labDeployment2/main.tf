
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.41.0"
    }
  }

  required_version = ">= 0.14.9"
}


provider "aws" {
  profile = "default"
  region  = local.region
}


locals {
  region             = "ap-southeast-1"
  vpc_cidr_block     = "10.0.0.0/16"
  subnets_cidr_block = "10.0.1.0/24"

  instance_type = "t2.micro"
  common_tags = {
    source  = "terraform"
    project = "codestar-frontend"
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
  name        = "allow-ssh-lab2-system"
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

resource "aws_security_group" "allow_http_port" {
  name        = "allow-http-port-lab2-system"
  description = "Allow Port 80 inbound traffic"

  ingress { // inbound
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type


  security_groups = [aws_security_group.allow_ssh.name, aws_security_group.allow_http_port.name]

  tags = local.common_tags

  key_name  = aws_key_pair.keypair.key_name
  user_data = templatefile("./script/userdata.sh", {})
}

### Export key pair and save to local file in this folder
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair" {
  key_name   = "codestar-deployment-key"
  public_key = tls_private_key.private_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.private_key.private_key_pem}' > ./codestar-deployment-key.pem && chmod 400 ./codestar-deployment-key.pem"
  }
}
