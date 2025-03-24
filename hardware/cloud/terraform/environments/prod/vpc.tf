locals {
  environment = "prod"
  name_prefix = "p"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.name_prefix}-homelab-vpc"

  # Overlaps with `nuage`, but almost certainly will terminate the `nuage` VPC.
  cidr = "10.0.0.0/16"

  azs            = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.0.111.0/24", "10.0.112.0/24"]
  public_subnet_tags = {
    public = "true"
  }

  tags = {
    Name      = "${local.name_prefix}-homelab-vpc"
    name      = "${local.name_prefix}-homelab-vpc"
    env       = local.environment
    Terraform = "true"
    project   = "homelab"
  }
}
