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
}



output "network_vpc" {
  value = module.network_vpc
}