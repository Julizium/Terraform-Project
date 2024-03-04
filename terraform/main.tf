
module "vpc" {
  source          = "./modules/VPC"
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}


module "lighting_dynamodb" {
  source       = "./modules/dynamodb"
  table_name   = "Lighting"
  hash_key     = "id"
  hash_key_type = "S"
}

module "heating_dynamodb" {
source       = "./modules/dynamodb"
  table_name   = "Heating"
  hash_key     = "id"
  hash_key_type = "S"
}