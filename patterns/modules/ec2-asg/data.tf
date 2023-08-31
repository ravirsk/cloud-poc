data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = ["vpc-0b4af206588ab6928"]
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = var.db_remote_state_bucket
    key    = var.db_remote_state_key
    region = "us-east-1"
  }
}
