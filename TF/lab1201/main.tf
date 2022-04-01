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
  vpc_id        = "vpc-019fd1323e1610f3f"    #var.vpc_id
  subnet        = "subnet-07d3da7f8b74a69d3" # var.subnet_id
  instance_type = var.instance_type
  instance_name = var.instance_name

  ami = var.ami

  common_tags = var.common_tags
}

module "public_ec2" {
  source = "./module/public_ec2"

  vpc_id        = "vpc-019fd1323e1610f3f"
  subnet_id     = local.subnet
  instance_type = local.instance_type
  instance_name = local.instance_name
  ami           = local.ami
  common_tags   = local.common_tags
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  #   enable_nat_gateway = true
  #   enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
