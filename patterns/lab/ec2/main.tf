provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "tf-ssc-aws-state-lab"
    key    = "lab/ec2/terraform.tfstate"
    region = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "tf-ssc-aws-state-lab-locks"
    encrypt        = true
  }
}


module "ec2_lab" {
  source = "../../modules/ec2"
  #Using Github versioning
  #source = "github.com/foo/modules/services/webserver-cluster?ref=v0.0.2"

  aws_vpc_id    = "vpc-0b4af206588ab6928"
  aws_subnet_id = "subnet-0a5da20231a5ac5bb"

  aws_instance_name     = "IAC-ec2-Standalone"
  aws_ec2_instance_type = "t2.micro"
  aws_ami_id            = "ami-06ca3ca175f37dd66"

  #db_remote_state_bucket = "ssc-lab-terraform-state"
  #db_remote_state_key    = "lab/ec2/terraform.tfstate"
}

