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

output "oidc_provider_arn" {
  description = "Cluster OIDC Provider Arn"
  value       = module.eks.oidc_provider_arn
}