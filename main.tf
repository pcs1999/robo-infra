module "network_vpc" {
  source     = "github.com/pcs1999/tf_module_vpc.git"
  env        = var.env
  default_vpc_id = var.default_vpc_id

  for_each   = var.vpc
  cidr_block = each.value.cidr_block

}



module "subnets" {
  source     = "github.com/pcs1999/tf-module-subnet.git"
  env        = var.env
  default_vpc_id = var.default_vpc_id

  for_each   = var.subnets
  cidr_block = each.value.cidr_block
  name = each.value.name
  availability_zones = each.value.availability_zones
  vpc_id = lookup(lookup(module.network_vpc,each.value.vpc_name,null ),"vpc_id",null )
  vpc_peering_connection_id = lookup(lookup(module.network_vpc,each.value.vpc_name,null ),"vpc_peering_connection_id",null )
  internet_gw_id = lookup(lookup(module.network_vpc,each.value.vpc_name,null ),"internet_gw_id",null )

  internet_gw = lookup(each.value, "internet-gw" , false )
  nat_gw = lookup(each.value,"nat_gw",false )
}

output "vpc_id" {
  value = module.subnets
}