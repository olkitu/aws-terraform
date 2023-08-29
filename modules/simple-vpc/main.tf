/**
* # Simple VPC
* 
* Deploy simple VPC to AWS with:
* * 2x public and private Subnets
* * Single NAT Gateway
* * IPv6 Egress gateway
*
* ```hcl
* module "vpc" {
*  source = "github.com/olkitu/aws-terraform.git/modules/simple-vpc"
*
*   name = "aws-demo"
* }
* ```
*/

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = local.name
  cidr = var.cidr
  azs  = ["${local.region}a", "${local.region}b"]

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_ipv6                                    = true
  public_subnet_assign_ipv6_address_on_creation  = true
  private_subnet_assign_ipv6_address_on_creation = true

  # Create IPv6 outgoing only gateway. Inbound then only way via Load Balancer example.
  create_egress_only_igw = var.create_egress_only_igw

  public_subnet_ipv6_prefixes  = [0, 1]
  private_subnet_ipv6_prefixes = [2, 3]

  enable_nat_gateway = true
  single_nat_gateway = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.tags

  public_subnet_tags = merge({
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/elb"              = "1"
  })

  private_subnet_tags = merge({
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = "1"
  })
}