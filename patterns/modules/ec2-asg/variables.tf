variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 80
}

variable "aws_vpc_id" {
  description = "VPC ID where to create resources"
  type        = string
}

variable "aws_subnet_id" {
  description = "VPC Subnet ID where to create resources"
  type        = string
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


variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type        = string
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
  type        = string
}


variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
}

variable "key_pair_name" {
  type    = string
  default = "demokeypair"
}

