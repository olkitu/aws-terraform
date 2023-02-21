output "aws_region" {
  description = "Current AWS Region"
  value       = data.aws_region.current.name
}

output "bastion_id" {
  description = "Bastion Instance ID"
  value       = module.bastion.id
}

output "rds_address" {
  description = "RDS Instance Address"
  value       = module.rds-instance.db_instance_address
}

output "rds_port" {
  description = "RDS Instance Port"
  value       = module.rds-instance.db_instance_port
}

output "rds_username" {
  description = "RDS Instance admin username"
  value       = module.rds-instance.db_instance_username
  sensitive   = true
}

output "rds_password" {
  description = "RDS Instance admin user password"
  value       = module.rds-instance.db_instance_password
  sensitive   = true
}