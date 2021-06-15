provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  # source = "git::https://github.com/clouddrove/terraform-aws-vpc.git"
  source = "git::https://github.com/clouddrove/terraform-aws-vpc.git?ref=0.15"
  name   = "vpc"
  #  application = "clouddrove"
  environment = "test"
  # label_order = ["name", "environment"]

  cidr_block = "172.16.0.0/16"
}

module "public_subnets" {
  source = "git::git@github.com:clouddrove/terraform-aws-subnet.git?ref=0.15"
  # version = "0.15.0"
  name       = "public-subnet"
  repository = "https://registry.terraform.io/modules/clouddrove/subnet/aws/latest"
  #  application = "clouddrove"
  environment = "test"
  # label_order = ["environment", "application", "name"]

  availability_zones = ["eu-west-1b", "eu-west-1c"]
  vpc_id             = module.vpc.vpc_id
  type               = "public"
  igw_id             = module.vpc.igw_id
  cidr_block         = module.vpc.vpc_cidr_block
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block
}


module "vpn" {
  source = "./../"
  name   = "vpn"
  # application = "clouddrove"
  environment = "test"
  # label_order = ["environment", "application", "name"]

  vpc_id              = module.vpc.vpc_id
  customer_ip_address = "115.160.246.74"
}
