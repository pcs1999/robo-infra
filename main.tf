module "network_vpc" {
  source     = "github.com/pcs1999/tf_module_vpc.git"
  env        = var.env
  default_vpc_id = var.default_vpc_id

  for_each   = var.vpc
  cidr_block = each.value.cidr_block
  public_subnets = each.value.public_subnets
  private_subnets = each.value.private_subnets
  availability_zones = each.value.availability_zones


}



module "docdb" {
  source = "github.com/pcs1999/tf-documentDB.git"
  env    = var.env
  for_each = var.docdb
  subnet_ids = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null), "private_subnets_ids", null), each.value.subnets_name, null), "subnet_id", null )
// the subnet_ids is taking from output of module.network_vpc
  allow_cidr = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name,null),"private_subnets",null), "app",null), "cidr_block", null)
  vpc_id = lookup(lookup(module.network_vpc, each.value.vpc_name , null), "vpc_id", null) // strings are in double quotes,expressions are not exp=each.value.vpc_name , strings="vpc_id"
  engine_version = each.value.engine_version
  number_of_instances = each.value.number_of_instances
  instance_class = each.value.instance_class
}




module "rds" {
  source = "github.com/pcs1999/tf_module_rds.git"
  env    = var.env
  for_each = var.rds
  subnet_ids = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null), "private_subnets_ids", null), each.value.subnets_name, null), "subnet_id", null )
  // the subnet_ids is taking from output of module.network_vpc
  allow_cidr = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name,null),"private_subnets",null), "app",null), "cidr_block", null)
  vpc_id = lookup(lookup(module.network_vpc, each.value.vpc_name , null), "vpc_id", null) // strings are in double quotes,expressions are not exp=each.value.vpc_name , strings="vpc_id"
  engine_version = each.value.engine_version
  engine = each.value.engine
  number_of_instances = each.value.number_of_instances
  instance_class = each.value.instance_class

}

module "elasticache" {
  source = "github.com/pcs1999/tf_module_elastic_cache.git"
  env    = var.env
  for_each = var.elasticache
  subnet_ids = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null), "private_subnets_ids", null), each.value.subnets_name, null), "subnet_id", null )
  // the subnet_ids is taking from output of module.network_vpc
  allow_cidr = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name,null),"private_subnets",null), "app",null), "cidr_block", null)
  vpc_id = lookup(lookup(module.network_vpc, each.value.vpc_name , null), "vpc_id", null) // strings are in double quotes,expressions are not exp=each.value.vpc_name , strings="vpc_id"
  replicas_per_node_group = each.value.replicas_per_node_group
  num_node_groups = each.value.num_node_groups
  node_type = each.value.node_type

}

module "rabbitmq" {
  source = "github.com/pcs1999/tf-module-rabbittmq.git"
  env    = var.env
  for_each = var.rabbitmq
  subnet_ids = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null), "private_subnets_ids", null), each.value.subnets_name, null), "subnet_id", null )
  allow_cidr = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name,null),"private_subnets",null), "app",null), "cidr_block", null)
  vpc_id = lookup(lookup(module.network_vpc, each.value.vpc_name , null), "vpc_id", null) // strings are in double quotes,expressions are not exp=each.value.vpc_name , strings="vpc_id"
  engine_version = each.value.engine_version
  engine_type =  each.value.engine_type
  host_instance_type =  each.value.host_instance_type
  deployment_mode =  each.value.deployment_mode
}

module "alb" {
  source = "github.com/pcs1999/tf-module-alb.git"
  env    = var.env
  for_each = var.alb
  subnet_ids = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null), each.value.subnets_type, null), each.value.subnets_name, null), "subnet_id", null )
  allow_cidr = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name,null),"private_subnets",null), "app",null), "cidr_block", null)
  vpc_id = lookup(lookup(module.network_vpc, each.value.vpc_name , null), "vpc_id", null) // strings are in double quotes,expressions are not exp=each.value.vpc_name , strings="vpc_id"
  subnets_name = each.value.subnets_name
  internal = each.value.internal
}

module "app" {
  source = "github.com/pcs1999/tf-module-app.git"
  env    = var.env
  for_each = var.app
  subnet_ids = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null), each.value.subnets_type, null), each.value.subnets_name, null), "subnet_id", null )
  allow_cidr = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name,null),"private_subnets",null), "app",null), "cidr_block", null)
  vpc_id = lookup(lookup(module.network_vpc, each.value.vpc_name , null), "vpc_id", null) // strings are in double quotes,expressions are not exp=each.value.vpc_name , strings="vpc_id"
  subnets_name = each.value.subnets_name
  component = each.value.component
  app_port = each.value.app_port
}


output "network_vpc" {
  value = module.network_vpc
}