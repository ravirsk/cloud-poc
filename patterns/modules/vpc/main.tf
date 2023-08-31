####### RDS GIT example - https://github.com/hashicorp/learn-terraform-rds

//network.tf
resource "aws_vpc" "test-env" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags {
    Name = "test-env"
  }
}

################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = "education"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

#subnet groups 
resource "aws_db_subnet_group" "education" {
  name       = "education"
  subnet_ids = module.vpc.public_subnets

  tags = {
    Name = "Education"
  }
}

# DB Instance 
resource "aws_db_instance" "education" {
  identifier             = "education"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.1"
  username               = "edu"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.education.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.education.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}

# Parameter Group 
resource "aws_db_parameter_group" "education" {
  name   = "education"
  family = "postgres14"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}
# Variables 
variable "db_password" {
  description = "RDS root user password"
  type        = string
  sensitive   = true
}

# out put varaibels
output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.education.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.education.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.education.username
  sensitive   = true
}

# Execute 
# export TF_VAR_db_password="hashicorp" followed by init, apply
 
 
################## Read Replica ##########################

resource "aws_db_instance" "education_replica" {
   name                   = "education-replica"
   identifier             = "education-replica"
   replicate_source_db    = aws_db_instance.education.identifier
   instance_class         = "db.t3.micro"
   apply_immediately      = true
   publicly_accessible    = true
   skip_final_snapshot    = true
   vpc_security_group_ids = [aws_security_group.rds.id]
   parameter_group_name   = aws_db_parameter_group.education.name
}

## Backup retention period 
resource "aws_db_instance" "education" {
    name                      = "education"
    instance_class            = "db.t3.micro"
    allocated_storage         = 10
+   backup_retention_period   = 1
##...
}
