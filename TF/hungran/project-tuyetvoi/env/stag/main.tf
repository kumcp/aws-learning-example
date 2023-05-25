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
  profile = "hungran"
  region  = "ap-southeast-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"

  name = "vpc-lab4"
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.current_az_list.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]
  #   enable_nat_gateway = true
  #   enable_vpn_gateway = true
}


data "aws_availability_zones" "current_az_list" {
  state = "available"
}


module "ec2_with_sg" {
  source = "../../modules/ec2_sg"

  project_name  = "lab4"
  ami           = "ami-055d15d9cfddf7bd3"
  instance_type = "t2.micro"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[1]
}


module "ec2_with_sg" {
  for_each = var.ec2_instances
  source = "../../modules/ec2_sg"

  project_name  = "lab4"
  ami           = "ami-055d15d9cfddf7bd3"
  instance_type = "t2.micro"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[1]
}
