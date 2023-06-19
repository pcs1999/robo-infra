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
  num_cache_nodes = each.value.num_cache_nodes
  node_type = each.value.node_type
  engine_version = each.value.engine_version

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
  bastion_cidr =var.bastion_cidr

}

#module "alb" {
#  source = "github.com/pcs1999/tf-module-alb.git"
#  env    = var.env
#  for_each = var.alb
#  subnet_ids = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null), each.value.subnets_type, null), each.value.subnets_name, null), "subnet_id", null )
#  allow_cidr   = each.value.internal ? concat(lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), "private_subnets", null), "web", null), "cidr_block", null), lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), "private_subnets", null), "app", null), "cidr_block", null)) : ["0.0.0.0/0"]
#  //allow_cidr   = each.value.internal ? lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name, null), "private_subnets", null), "web", null), "cidr_block", null) : [ "0.0.0.0/0" ]
#  vpc_id = lookup(lookup(module.network_vpc, each.value.vpc_name , null), "vpc_id", null)
#  // strings are in double quotes,expressions are not exp=each.value.vpc_name , strings="vpc_id"
#  subnets_name = each.value.subnets_name
#  internal = each.value.internal
#  dns_domain = each.value.dns_domain
#}

// this is only for server immutable and mutable approach

#module "app" {
#  source = "github.com/pcs1999/tf-module-app.git"
#  depends_on = [module.docdb, module.rds, module.elasticache, module.rabbitmq]
#  env    = var.env
#  for_each = var.app
#  alb       = lookup(lookup(module.alb, each.value.alb,null ), "dns_name",null)
#  listener = lookup(lookup(module.alb, each.value.alb,null ), "listener",null)
#  subnet_ids = lookup(lookup(lookup(lookup(module.network_vpc, each.value.vpc_name, null), each.value.subnets_type, null), each.value.subnets_name, null), "subnet_id", null )
#  allow_cidr = lookup(lookup(lookup(lookup(var.vpc, each.value.vpc_name,null),each.value.allow_cidr_subnet_types,null), each.value.allow_cidr_subnet_name,null), "cidr_block", null)
#  vpc_id = lookup(lookup(module.network_vpc, each.value.vpc_name , null), "vpc_id", null) // strings are in double quotes,expressions are not exp=each.value.vpc_name , strings="vpc_id"
#  component = each.value.component
#  alb_arn = lookup(lookup(module.alb, each.value.alb,null ), "alb_arn",null)
#  app_port = each.value.app_port
#  max_size = each.value.max_size
#  min_size = each.value.min_size
#  desired_capacity = each.value.desired_capacity
#  instance_type = each.value.instance_type
#  bastion_cidr =var.bastion_cidr
#  monitor_cidr = var.monitor_cidr
#  listener_priority = each.value.listener_priority
#}



output "network_vpc" {
  value = module.network_vpc
}


#module "minikube" {
#  source = "github.com/scholzj/terraform-aws-minikube"
#
#  aws_region        = "us-east-1"
#  cluster_name      = "minikube"
#  aws_instance_type = "t3.medium"
#  ssh_public_key    = "~/.ssh/id_rsa.pub"
#  aws_subnet_id     = element(lookup(lookup(lookup(lookup(module.network_vpc, "main", null), "public_subnets_ids", null), "public", null), "subnet_id", null ), 0)
#  //ami_image_id        = data.aws_ami.ami.id
#  hosted_zone         = var.Hosted_zone
#  hosted_zone_private = false
#
#  tags = {
#    Application = "Minikube"
#  }
#
#  addons = [
#    "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/storage-class.yaml",
#    "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/heapster.yaml",
#    "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/dashboard.yaml",
#    "https://raw.githubusercontent.com/scholzj/terraform-aws-minikube/master/addons/external-dns.yaml"
#  ]
#}
#
#output "MINIKUBE_SERVER" {
#  value = "ssh centos@${module.minikube.public_ip}"
#}
#
#output "KUBE_CONFIG" {
#  value = "scp centos@${module.minikube.public_ip}:/home/centos/kubeconfig ~/.kube/config"
#}


module "eks" {
  source                 = "github.com/r-devops/tf-module-eks"
  ENV                    = var.env
  PRIVATE_SUBNET_IDS     = lookup(lookup(lookup(lookup(module.network_vpc, "main", null), "private_subnets_ids", null), "app", null), "subnet_id", null)
  PUBLIC_SUBNET_IDS      = lookup(lookup(lookup(lookup(module.network_vpc, "main", null), "public_subnets_ids", null), "public", null), "subnet_id", null)
  DESIRED_SIZE           = 2
  MAX_SIZE               = 2
  MIN_SIZE               = 2
  CREATE_PARAMETER_STORE = true
}