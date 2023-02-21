/**
* # Secure RDS Connection via Bastion Host
* 
* Using Session Manager port forwarding feature no need expose any ports to internet. With IAM Authentication all events logged to CloudTrail.
* 
* Deploy this example using terraform:
* ```
* terraform plan
* terraform apply
* ```
* 
* After successful deployment you can use script to connect to database.
* `bash connect-to-rds.sh`
*/
data "aws_region" "current" {}

module "vpc" {
  source = "../../modules/simple-vpc"

  name = "aws-demo"
}

module "rds-instance" {
  source = "../../modules/rds-multi-az-instance"

  name = "aws-demo"

  vpc_id         = module.vpc.vpc_id
  vpc_subnet_ids = module.vpc.private_subnets

  create_replica_db_instance = false
  deletion_protection        = false
}

module "bastion" {
  source = "../../modules/bastion-host"

  name = "aws-demo"

  vpc_id         = module.vpc.vpc_id
  vpc_subnet_ids = module.vpc.private_subnets

}