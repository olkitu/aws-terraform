output "db_instance_address" {
  description = "Database Instance Address"
  value       = module.master.db_instance_address
}

output "db_instance_arn" {
  description = "Database Master Instance Arn"
  value       = module.master.db_instance_arn
}

output "db_instance_ca_cert_identifier" {
  description = "Database CA Certificate Identifier"
  value       = module.master.db_instance_ca_cert_identifier
}

output "db_instance_port" {
  description = "Database Port"
  value       = module.master.db_instance_port
}

output "db_instance_username" {
  description = "Database Instance account usename"
  value       = module.master.db_instance_username
}

output "db_instance_password" {
  description = "Database Instance account password"
  value       = module.master.db_instance_password
}