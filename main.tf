module "network_vpc" {
  source     = "github.com/pcs1999/tf_module_vpc.git"
  env        = var.env
  default_vpc_id = var.default_vpc_id

  for_each   = var.vpc
  cidr_block = each.value.cidr_block
  public_subnets_cidr = each.value.public_subnets_cidr
  private_subnets_cidr = each.value.private_subnets_cidr
  availability_zones  = each.value.availability_zones

}



