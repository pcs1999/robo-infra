env = "prod"
default_vpc_id =  "vpc-0738d5702c63820c7"
bastion_cidr = ["172.31.3.234/32"]
monitor_cidr = ["172.31.0.51/32"]
#elk_cidr     = ["172.31.7.4/32"]

vpc = {
  main = {
    cidr_block = "10.100.0.0/16"
    availability_zones = ["us-east-1a", "us-east-1b"]

    public_subnets = {
      public = {
        name = "public"
        cidr_block =  ["10.100.0.0/24", "10.100.1.0/24"]
        internet_gw  = true
      }
    }
    private_subnets = {
      web = {
        name       = "web"
        cidr_block = ["10.100.2.0/24", "10.100.3.0/24"]
        nat_gw     = true
      }

      app = {
        name       = "app"
        cidr_block = ["10.100.4.0/24", "10.100.5.0/24"]
        nat_gw     = true

      }

      db = {
        name       = "db"
        cidr_block = ["10.100.6.0/24", "10.100.7.0/24"]
        nat_gw     = true

      }
    }

  }
}

docdb = {
  main = {
    vpc_name = "main"
    subnets_name = "db"
    engine_version = "4.0.0"
    number_of_instances = 1
    instance_class = "db.t3.medium"
  }
}

rds = {
  main = {
    vpc_name = "main"
    subnets_name = "db"
    engine_version = "5.7.mysql_aurora.2.11.1"
    engine = "aurora-mysql"
    number_of_instances = 1
    instance_class = "db.t3.small"
  }
}

elasticache = {
  main = {
    vpc_name = "main"
    subnets_name = "db"
    num_cache_nodes = 1
    node_type = "cache.t3.micro"
    engine_version = "6.x"
  }
}

rabbitmq = {
  main = {
    vpc_name = "main"
    engine_version = "3.10.10"
    engine_type    = "RabbitMQ"
    subnets_name = "db"
    host_instance_type= "mq.t3.micro"
    deployment_mode = "SINGLE_INSTANCE"

  }
}

alb = {
  public = {
    vpc_name = "main"
    subnets_type = "public_subnets_ids"
    subnets_name = "public"
    internal = false

  }

  private = {
    vpc_name = "main"
    subnets_type = "private_subnets_ids"
    subnets_name = "app"
    internal = true
  }
}

app = {
  frontend = {
    component = "frontend"
    vpc_name = "main"
    subnets_type = "private_subnets_ids"
    subnets_name = "web"
    app_port = 80
    allow_cidr_subnet_types = "public_subnets"
    allow_cidr_subnet_name = "public"
    max_size                  = 5
    min_size                  = 2
    desired_capacity          = 2
    alb                       = "public"
    instance_type = "t3.medium"
    listener_priority = 0
  }

  catalogue = {
    component = "catalogue"
    vpc_name = "main"
    subnets_type = "private_subnets_ids"
    subnets_name = "app"
    app_port = 8080
    allow_cidr_subnet_types = "private_subnets"
    allow_cidr_subnet_name = "app"
    max_size                  = 5
    min_size                  = 2
    desired_capacity          = 2
    alb                       = "private"
    listener_priority = 100
    instance_type = "t3.medium"

  }
  user = {
    component = "user"
    vpc_name = "main"
    subnets_type = "private_subnets_ids"
    subnets_name = "app"
    app_port = 8080
    allow_cidr_subnet_types = "private_subnets"
    allow_cidr_subnet_name = "app"
    max_size                  = 5
    min_size                  = 2
    desired_capacity          = 2
    alb                       = "private"
    listener_priority = 101

    instance_type = "t3.medium"

  }
  cart = {
    component                = "cart"
    vpc_name                 = "main"
    subnets_type             = "private_subnets_ids"
    subnets_name             = "app"
    app_port                 = 8080
    allow_cidr_subnet_types  = "private_subnets"
    allow_cidr_subnet_name   = "app"
    max_size                  = 5
    min_size                  = 2
    desired_capacity          = 2
    instance_type            = "t3.medium"
    alb                      = "private"
    listener_priority        = 102


  }
  shipping = {
    component = "shipping"
    vpc_name = "main"
    subnets_type = "private_subnets_ids"
    subnets_name = "app"
    app_port = 8080
    allow_cidr_subnet_types = "private_subnets"
    allow_cidr_subnet_name = "app"
    max_size                  = 10
    min_size                  = 3
    desired_capacity          = 3
    alb                       = "private"
    listener_priority = 103

    instance_type = "t3.large"

  }

  payment = {
    component = "payment"
    vpc_name = "main"
    subnets_type = "private_subnets_ids"
    subnets_name = "app"
    app_port = 8080
    allow_cidr_subnet_types = "private_subnets"
    allow_cidr_subnet_name = "app"
    max_size                  = 5
    min_size                  = 2
    desired_capacity          = 2
    alb                       = "private"
    listener_priority = 104

    instance_type = "t3.medium"

  }
}




