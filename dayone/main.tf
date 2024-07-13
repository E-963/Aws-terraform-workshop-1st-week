terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

# Create a VPC

resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = "tf_vpc"
    Environment = "terraformChamps"
    Owner       = "Sama"
  }
}

# create a public subnet in tf-vpc
resource "aws_subnet" "sub-1" {
  vpc_id            = aws_vpc.tf_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name        = "sub-1"
    Environment = "terraformChamps"
    Owner       = "Sama"
  }
}

# Create internet gateway attached to the subent.
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name        = "tf_igw" #igw name
    Environment = "terraformChamps"
    Owner       = "Sama"
  }
}

# Create route table to route all trrafic to the internet gateway.
resource "aws_route_table" "rt-1" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0" # Route all traffic to the internet
    gateway_id = aws_internet_gateway.tf_igw.id
  }
  tags = {
    Name        = "rt-1"
    Environment = "terraformChamps"
    Owner       = "Sama"
  }
}

// Connect Routing Table with the Public Subnet

resource "aws_route_table_association" "rt-assoc-1" {
  subnet_id      = aws_subnet.sub-1.id
  route_table_id = aws_route_table.rt-1.id
}