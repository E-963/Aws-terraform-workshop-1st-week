terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.58.0"
    }
  }
  backend "s3" {
    bucket         = "main-buc-1" 
    key            = "terraform.tfstate"
    region         = "us-east-1"
 }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "default" 
}