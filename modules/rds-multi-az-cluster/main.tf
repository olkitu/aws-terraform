module "cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.2.2"

  name           = "${var.name}-dbcluster"
  engine         = var.engine
  engine_mode    = "provisioned"
  engine_version = var.engine_version
  instance_class = var.instance_class
  instances = {
    one = {}
    two = {}
  }

  vpc_id  = var.vpc_id
  subnets = var.vpc_subnet_ids

  allowed_cidr_blocks = [var.vpc_cidr_block]

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  db_parameter_group_name         = "default"
  db_cluster_parameter_group_name = "default"

  tags = local.tags
}