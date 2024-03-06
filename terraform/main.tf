
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

# autoscaling

module "autoscaling-lighting" {
  source               = "./modules/autoscaling"
  asg_name             = "lighting-asg"
  template_name = "lighting-template"
  subnet_ids = module.vpc.public_subnets_ids
  target_group_arn     = module.load-balancers.target_groups_arn[0]
  image_id = "ami-0e5f882be1900e43b"

  security_group_ids = module.security.security_group_ids
  }

  module "autoscaling-heating" {
  source               = "./modules/autoscaling"
  asg_name             = "heating-asg"
  template_name = "heating-template"
  subnet_ids = module.vpc.public_subnets_ids
  target_group_arn     = module.load-balancers.target_groups_arn[3]
  image_id = "ami-07b108fd814778f00"
  security_group_ids = module.security.security_group_ids
  }

  module "autoscaling-status" {
  source               = "./modules/autoscaling"
  asg_name             = "status-asg"
  template_name = "status-template"
  subnet_ids = module.vpc.public_subnets_ids
  target_group_arn     = module.load-balancers.target_groups_arn[1]
  image_id = "ami-03e22e98884ea75d1"
  security_group_ids = module.security.security_group_ids
  }

  module "autoscaling-auth" {
  source               = "./modules/autoscaling"
  asg_name             = "auth-asg"
  template_name = "auth-template"
  subnet_ids = module.vpc.public_subnets_ids
  target_group_arn     = module.load-balancers.target_groups_arn[2]
  image_id = "ami-0b21a306f6c22e3c4"
  security_group_ids = module.security.security_group_ids
  }

