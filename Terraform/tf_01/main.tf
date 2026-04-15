terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Add this ABOVE your resource block
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical (Ubuntu's publisher) AWS account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "express_flask_sg" {
  name= "express_flask_sg"
  description = "Allow SSH, Flask, Express traffic"

  ingress{
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress{
    description = "Flask"
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress{
    description = "Express"
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"            # ← "-1" means ALL protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "app" {
  ami=data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.express_flask_sg.id]
  user_data              = file("${path.module}/user_data.sh")
  tags = {
    Name = "express_flask_terraform"
  }
}
