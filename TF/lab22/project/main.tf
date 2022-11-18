terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.40.0"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
}

locals {
  project_name  = var.project_name
  instance_type = var.instance_type

  common_tags = {
    Environment = "dev"
    Project     = var.project_name
    Terraform   = "true"
  }
}


module "lab22_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["ap-southeast-1a"]
  public_subnets = ["10.0.1.0/24"]

  tags = local.common_tags
}

resource "aws_s3_bucket" "lab22_bucket" {
  bucket = "lab22-bucket"

  tags = local.common_tags
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

  owners = ["099720109477"] # Canonical
}


resource "aws_iam_role" "lab22_role" {
  name = "lab22_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com" // Assume role allows which service can use this role
        }
      },
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonS3FullAccess"]

  tags = local.common_tags
}


resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh-lab22"
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

resource "aws_iam_instance_profile" "profile" {

  name = "profile_lab22"
  role = aws_iam_role.lab22_role.id
}

resource "aws_instance" "lab22_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type


  security_groups = [aws_security_group.allow_ssh.name]

  iam_instance_profile = aws_iam_instance_profile.profile.name

  tags = local.common_tags
}
