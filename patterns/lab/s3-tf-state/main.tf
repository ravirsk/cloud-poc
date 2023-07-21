provider "aws" {
  region = "us-east-1"
}

module "s3-state-bucket" {
  source = "../../modules/s3-tf-state"

  s3_bucket_prefix = "lab"
  # bucket will be tf-ssc-aws-state-$prefix

}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "tf-ssc-aws-state-lab"
    key    = "global/s3-tfstate/terraform.tfstate"
    region = "us-east-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "tf-ssc-aws-state-lab-locks"
    encrypt        = true
  }
}  