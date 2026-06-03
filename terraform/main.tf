terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Generate a new SSH key pair
resource "tls_private_key" "my_ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair from generated public key
resource "aws_key_pair" "my_ec2_key" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.my_ec2_key.public_key_openssh

  tags = {
    Name = var.key_pair_name
  }
}

# Security Group
resource "aws_security_group" "my_ec2_sg" {
  name        = var.security_group_name
  description = "Security group for ${var.instance_name}"
  vpc_id      = var.vpc_id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Application port 4444
  ingress {
    from_port   = 4444
    to_port     = 4444
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress - allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group_name
  }
}

# EC2 Instance
resource "aws_instance" "my_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.my_ec2_key.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.my_ec2_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }
}
