module "network_vpc" {
  source = "github.com/pcs1999/tf_module_vpc.git"

  for_each = var.vpc
  cidr_block = each.value.cidr_block
}
