terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.72.0"
    }

  }
}

provider "aws" {
  region = "ap-southeast-1"
}


###### Self custom vpc module

# module "vpc" {
#   source = "../../module/vpc"

#   environment = "stag"
# }

###### Pre defined AWS modules

locals {
  project_name = var.appname # "demo"

  vpc_cidr          = "10.0.0.0/16"
  private_nets_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
  public_nets_cidr  = ["10.0.3.0/24", "10.0.4.0/24"]

  instance_type = "t2.micro"
  instance_name = "stag-instance"

  common_tags = {
    Project     = local.project_name
    Environment = var.env # "stag"
  }
}

data "aws_availability_zones" "current_az_list" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"


  name = join("-", tolist(["vpc", local.project_name]))
  cidr = local.vpc_cidr

  azs             = data.aws_availability_zones.current_az_list.names
  private_subnets = local.private_nets_cidr
  public_subnets  = local.public_nets_cidr

  #   enable_nat_gateway = true
  #   enable_vpn_gateway = true

  tags = local.common_tags

}


module "public_ec2" {
  source = "../../module/public_ec2"

  vpc_id        = module.vpc.vpc_id
  subnet_id     = module.vpc.private_subnets[0]
  instance_type = local.instance_type
  instance_name = local.instance_name

  common_tags = local.common_tags
}


module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "alb"

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.public_ec2.allow_http_sg]

  # access_logs = {
  #   bucket = "my-alb-logs"
  # }

  target_groups = [
    {
      name             = "${local.project_name}-tg1"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = module.public_ec2.instance_id
          port      = 80
        }
      ]
    }
  ]


  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Test"
  }
}

# module "database" {
#   source = "../module/db"
# }
