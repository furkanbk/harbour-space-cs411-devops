variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
  default     = "harbour-space-app"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for the instance (Ubuntu 22.04 LTS in eu-north-1)"
  type        = string
  default     = "ami-095e44eb80ff16c3f" # Ubuntu 22.04 LTS
}

variable "key_pair_name" {
  description = "Name of the key pair"
  type        = string
  default     = "harbour-space-key"
}

variable "security_group_name" {
  description = "Name of the security group"
  type        = string
  default     = "harbour-space-sg"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-0c37569dc613b8d2a"
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
  default     = "subnet-05d561f9d1ec007e2"
}
