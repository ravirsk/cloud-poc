variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "env_prefix" {
  description = "The password for the database"
  type        = string
}

variable "database_name" {
  description = "The password for the database"
  type        = string
}

variable "instance_class" {
  description = "The password for the database"
  type        = string
}

variable "engine" {
  description = "The password for the database"
  type        = string
}

variable "aws_vpc_id" {
  description = "VPC ID where to create resources"
  type        = string
}