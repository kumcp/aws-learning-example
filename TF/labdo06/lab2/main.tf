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


module "ec2_with_sg" {
  source = "../lab1"

  subnet        = module.vpc.public_subnets[0]
  instance_type = "t3.micro"
  ami           = "ami-055d15d9cfddf7bd3"
  project_name  = "module"
  vpc_id        = module.vpc.vpc_id
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "module_vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

output "public_subnet1" {
  value = module.vpc.public_subnets[0]
}
