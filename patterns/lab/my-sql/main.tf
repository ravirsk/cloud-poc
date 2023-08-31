provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "tf-ssc-aws-state-lab"
    key    = "lab/data-store/mysql/terraform.tfstate"
    region = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "tf-ssc-aws-state-lab-locks"
    encrypt        = true
  }
}


module "mysql-db" {
  source = "../../modules/data-store/mysql"

  aws_vpc_id    = "vpc-0b4af206588ab6928"
  env_prefix    = "mysql-db-lab"
  database_name = "tfstatedb"

  instance_class = "db.t2.micro"
  engine         = "mysql"

  db_username = "p_admin"
  db_password = "password123"

}
