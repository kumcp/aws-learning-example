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


module "project_instance" {
  source = "../../module/separate_ec2"

  ec2_instance_type = "t2.micro"
  ssh_cidr          = "10.0.0.0/16"
  project_name      = "demo-lab4"
}

data "aws_availability_zones" "current_az_list" {
  state = "available"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.current_az_list.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
