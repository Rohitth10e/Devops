terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
      }
    }
}

provider "aws" {
    region = "ap-south-1"
}

resource "aws_s3_bucket" "my_bucket_tf_demo" {
    bucket = "my-bucket-tf-demo"
    acl    = "private"
}