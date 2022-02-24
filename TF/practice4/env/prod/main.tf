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
  project_name = "myapp"

  common_tags = {
    Project     = local.project_name
    Environment = "stag"
  }
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"


  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  #   enable_nat_gateway = true
  #   enable_vpn_gateway = true

  tags = local.common_tags

}


# module "instance" {
#   source = "../module/ec2_ebs"
# }

resource "aws_network_interface" "instance_eni" {
  subnet_id = module.vpc.private_subnets[0]

  tags = merge(local.common_tags,
    tomap({
      Name = "primary_network_interface"
  }))
}

resource "aws_instance" "project_instance" {

  ami           = "ami-055d15d9cfddf7bd3"
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.instance_eni.id
    device_index         = 0
  }

  tags = merge(local.common_tags,
    tomap({
      Name = "demo"
  }))
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.common_tags,
    tomap({
      Name = "allow_http"
  }))

}

# resource "aws_lb_target_group_attachment" "tg_attachment" {
#   target_group_arn = module.alb.arn
#   target_id        = aws_instance.project_instance.id
#   port             = 80
# }

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "alb"

  load_balancer_type = "application"

  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.allow_http.id]

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
          target_id = aws_instance.project_instance.id
          port      = 80
        }
      ]
    }
  ]

  #   https_listeners = [
  #     {
  #       port               = 443
  #       protocol           = "HTTPS"
  #       certificate_arn    = "arn:aws:iam::123456789012:server-certificate/test_cert-123456789012"
  #       target_group_index = 0
  #     }
  #   ]

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
