module "network_vpc" {
  source = "github.com/pcs1999/tf_module_vpc.git"
  version = "main"

  for_each = var.vpc
  cidr_block = each.value.cidr_block
}
