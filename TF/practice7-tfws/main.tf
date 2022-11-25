terraform {
  cloud {
    organization = "kumcp-org"

    workspaces {
      name = "myws"
    }
  }

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

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"

  ingress {
    description = "HTTP from VPC"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  lifecycle {
    precondition {
      condition     = var.port >= 80 && var.port <= 90
      error_message = "Port number must be between 80 and 90"
    }
  }
}
