# Configure AWS provider
# And terraform backend

provider "aws" {
  region = var.AWS_region
}

## This section only runs once locally
## after that the backend provider is enabled
## for storing the tfstate file remoteley

###########################
## Create S3 bucket #######
###########################

#resource "aws_s3_bucket" "terraform_state" {
#  bucket = "eks-cluster-s3-state"
  # Enable versioning so we can see the full revision history of our
  # state files
#  versioning {
#    enabled = true
#  }
  # Enable server-side encryption by default
#  server_side_encryption_configuration {
#    rule {
#      apply_server_side_encryption_by_default {
#        sse_algorithm = "AES256"
#      }
#    }
#  }
#}

######################################
## Creating DynamoDB for locking state
######################################

#resource "aws_dynamodb_table" "terraform_locks" {
#  name         = "eks-cluster-DynamoDB-tfstate"
#  billing_mode = "PAY_PER_REQUEST"
#  hash_key     = "LockID"
#  attribute {
#    name = "LockID"
#    type = "S"
#  }
#}

terraform {
  backend "s3" {

    bucket         = "eks-cluster-s3-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"

    dynamodb_table = "eks-cluster-DynamoDB-tfstate"
    encrypt        = true
  }
}
