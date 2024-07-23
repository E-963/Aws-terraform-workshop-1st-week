terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.58.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "default" 
}

terraform {
  backend "s3" {
    bucket         = "erakiterrafromstatefiles" 
    key            = "terraform.tfstate"
    region         = "us-east-1"
}
}