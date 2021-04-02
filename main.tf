terraform {
  required_providers {
    aws = {
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "random_string" "random" {
  length  = 8
  upper   = false
  special = false
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>2.64.0"

  name = "vpc-${random_string.random.id}"
  cidr = var.vpc_cidr_block

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.common_tags
}

module "security_group_db" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~>3.0"

  name   = "database"
  vpc_id = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]
  egress_rules = ["all-all"]
  tags         = var.common_tags
}
