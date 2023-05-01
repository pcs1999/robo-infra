module "network_vpc" {
  source     = "github.com/pcs1999/tf_module_vpc.git"
  env        = var.env
  default_vpc_id = var.default_vpc_id

  for_each   = var.vpc
  cidr_block = each.value.cidr_block

}



module "subnet" {
  source     = "github.com/pcs1999/tf-module-subnet.git"
  env        = var.env
  default_vpc_id = var.default_vpc_id

  for_each   = var.subnet
  cidr_block = each.value.cidr_block
  name = each.value.name
  availability_zones = each.value.availability_zones
  vpc_id = lookup(lookup(module.network_vpc,each.value.vpc_name,null ),"vpc_id",null )

}

output "vpc_id" {
  value = lookup(lookup(module.network_vpc,"main",null ),"vpc_id",null )
}