provider "aws" {
  region = "us-east-1"
}


terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "tf-ssc-aws-state-lab"
    key    = "lab/ec2-asg/terraform.tfstate"
    region = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "tf-ssc-aws-state-lab-locks"
    encrypt        = true
  }
}

module "ec2_asg" {
  source = "../../modules/ec2-asg"

  aws_instance_name = "Terraform-ec2-lab"
  cluster_name      = "webservers-lab"

  db_remote_state_bucket = "tf-ssc-aws-state-lab"
  db_remote_state_key    = "lab/data-store/mysql/terraform.tfstate"

  aws_vpc_id    = "vpc-0b4af206588ab6928"
  aws_subnet_id = "subnet-0a5da20231a5ac5bb"

  aws_ec2_instance_type = "t2.micro"
  aws_ami_id            = "ami-06ca3ca175f37dd66"

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}

output "alb_dns_name" {
  value       = module.ec2_asg.alb_dns_name
  description = "The domain name of the load balancer"
}