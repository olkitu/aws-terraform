output "cluster_arn" {
  description = "Cluster Arn"
  value       = module.cluster.cluster_arn
}

output "cluster_endpoint" {
  description = "Cluster writer endpoint"
  value       = module.cluster.cluster_endpoint
}

output "cluster_reader_endpoint" {
  description = "Cluster Reader endpoint"
  value       = module.cluster.cluster_reader_endpoint
}

output "cluster_port" {
  description = "Cluster Port"
  value       = module.cluster.cluster_port
}

output "cluster_master_username" {
  description = "Cluster Master Username"
  value       = module.cluster.cluster_master_username
}

output "cluster_master_password" {
  description = "Cluster Master account password"
  value       = module.cluster.cluster_master_password
}

output "security_group_id" {
  description = "Cluster Security Group Id"
  value       = module.cluster.security_group_id
}