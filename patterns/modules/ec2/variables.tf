variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 80
}

variable "aws_instance_name" {
  description = "ec2 instance name"
  type        = string
}

variable "aws_ami_id" {
  description = "ec2 instance name"
  type        = string
}

variable "aws_ec2_instance_type" {
  description = "ec2 instance name"
  type        = string
}

variable "aws_vpc_id" {
  description = "VPC ID where to create resources"
  type        = string
}

variable "aws_subnet_id" {
  description = "VPC Subnet ID where to create resources"
  type        = string
}


