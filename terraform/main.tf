
module "vpc" {
  source          = "./modules/VPC"
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
  security_group_ids = module.security.security_group_ids

}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}


module "lighting_dynamodb" {
  source       = "./modules/dynamodb"
  table_name   = "Lighting"
  hash_key     = "id"
  hash_key_type = "N"
}

module "heating_dynamodb" {
source       = "./modules/dynamodb"
  table_name   = "Heating"
  hash_key     = "id"
  hash_key_type = "N"
}

module "servers" {
  source          = "./modules/servers"
  public_subnets  = module.vpc.public_subnets_ids
  private_subnets  = module.vpc.private_subnets_ids
  security_group_ids = module.security.security_group_ids
  ami = var.ami
}

module "load-balancers" {
  source                    = "./modules/load-balancers"
  vpc_id                    = module.vpc.vpc_id
  lb_security_groups        = module.security.security_group_ids
  public_lb_subnets         = module.vpc.public_subnets_ids
  private_lb_subnets        = module.vpc.private_subnets_ids
  aws_instance_ids             = module.servers.aws_instance_ids
}