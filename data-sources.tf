# Data block to fetch security group details from the vpc created by the VPC module
data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}