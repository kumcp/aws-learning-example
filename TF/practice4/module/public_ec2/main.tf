
locals {
  vpc_id        = var.vpc_id
  subnet        = var.subnet_id
  instance_type = var.instance_type
  instance_name = var.instance_name

  ami = var.ami

  common_tags = var.common_tags
}


resource "aws_network_interface" "instance_eni" {
  subnet_id = local.subnet
  tags      = local.common_tags
}

resource "aws_instance" "this" {

  ami           = local.ami
  instance_type = local.instance_type

  network_interface {
    network_interface_id = aws_network_interface.instance_eni.id
    device_index         = 0
  }

  tags = merge(local.common_tags,
    tomap({
      Name = local.instance_name
  }))
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = local.vpc_id

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

  tags = local.common_tags

}
