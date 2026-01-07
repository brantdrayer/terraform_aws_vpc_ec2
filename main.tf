terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=6.27.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Module to create a VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.1"

  name = "main"
  cidr = "10.0.0.0/16"

  azs                         = ["us-east-1a"]
  public_subnets              = ["10.0.101.0/24"]
  create_igw                  = true
  default_route_table_name    = "main"
  default_security_group_name = "main"

  tags = {
    Terraform = "true"
  }
}

# Module to create an ec2 instance in the vpc previously created using the AMI fetched in the data-sources.tf file.
module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.1.5"

  ami = "ami-068c0051b15cdb816"

  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [data.aws_security_group.default.id]
}