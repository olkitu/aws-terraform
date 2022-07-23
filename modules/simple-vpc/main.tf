module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = var.cidr
  azs  = ["${local.region}a", "${local.region}b"]

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_ipv6                                    = true
  assign_ipv6_address_on_creation                = true
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
}