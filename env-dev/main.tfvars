env = "dev"
default_vpc_id =  "vpc-0738d5702c63820c7"

vpc = {
  main = {
    cidr_block = "10.0.0.0/16"

  }
}

subnets = {
  public = {
  name = "public"
    cidr_block =  ["10.0.0.0/24 ", "10.0.1.0/24" ]
            availability_zones = ["us-east-1a", "us-east-1b"]

  }

  web = {

  }

  app = {

  }

  db = {

  }


}