

locals {
  ami           = var.ami
  instance_type = var.instance_type
  name          = var.project_name

  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id
}

resource "aws_instance" "myapp" {
  ami           = local.ami
  instance_type = local.instance_type
  subnet_id     = local.subnet_id

  tags = {
    Name = local.name
  }

  // NOTE: If subnet_id not included -> use SG name
  // If subnet_id included -> use SG id
  security_groups = [aws_security_group.allow_ssh.id]
}


resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh-lab2"
  description = "Allow SSH inbound traffic"
  vpc_id      = local.vpc_id

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

  tags = {
    Name = "allow_ssh"
  }
}
