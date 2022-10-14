/**
* # Example EKS with IPv6 only
* 
* This will deploy
* * VPC with IPv4+IPv6 Dual Stack
* * EKS with IPv6 only
* 
* ```
* terraform init
* terraform plan
* terraform apply
* ```
*/

module "vpc" {
  source = "../../modules/simple-vpc"

  name = local.name
  tags = local.tags
}

module "eks" {
  source = "../..//modules/eks-managed"

  name = local.name
  tags = local.tags

  vpc_id         = module.vpc.vpc_id
  vpc_subnet_ids = module.vpc.private_subnets

  cluster_version   = "1.23"
  cluster_ip_family = "ipv6"
}