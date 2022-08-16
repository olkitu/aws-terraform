output "cluster_id" {
  description = "Cluster Id"
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Cluster Endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Cluster Certificate Authority Data"
  value       = module.eks.cluster_certificate_authority_data
}

output "oidc_provider" {
  description = "Cluster OIDC Provider"
  value       = module.eks.oidc_provider
}

output "oidc_provider_arn" {
  description = "Cluster OIDC Provider Arn"
  value       = module.eks.oidc_provider_arn
}

output "node_group_amd64_iam_role_arn" {
  description = "Node Group amd64 role arn"
  value       = module.eks.eks_managed_node_groups["amd64"].iam_role_arn
}

output "node_group_amd64_iam_role_name" {
  description = "Node Groyup amd64 role name"
  value       = module.eks.eks_managed_node_groups["amd64"].iam_role_name
}
