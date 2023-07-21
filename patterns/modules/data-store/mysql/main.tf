resource "aws_db_instance" "mysql-db" {
	identifier_prefix   = var.env_prefix
	engine              = var.engine
	allocated_storage   = 10
	instance_class      = var.instance_class
	skip_final_snapshot = true
	db_name             = var.database_name

	db_subnet_group_name   = aws_db_subnet_group.labsubnetgrp.name
	vpc_security_group_ids = [aws_security_group.rdsSG.id]
	
	# How should we set the username and password?
	username = var.db_username
	password = var.db_password

}


resource "aws_security_group" "rdsSG" {
  name   	= "TerraStateDBSG"
  vpc_id    = var.aws_vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TerraStateDB_SG"
  }
}

resource "aws_db_subnet_group" "labsubnetgrp" {
  name       = "labsubnetgrp"
  subnet_ids = ["subnet-0a5da20231a5ac5bb", "subnet-004eb3b855ddc44fb"]

  tags = {
    Name = "labsubnetgrp"
  }
}

# Set before running
#set TF_VAR_db_username="(YOUR_DB_USERNAME)"
#set TF_VAR_db_password="(YOUR_DB_PASSWORD)"