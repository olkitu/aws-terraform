output "iam_role_arn" {
  description = "Load Balancer EKS Role Arn"
  value       = module.iam_loadbalancer_eks_role.iam_role_arn
}

output "iam_role_name" {
  description = "Load Balancer EKS Role Name"
  value       = module.iam_loadbalancer_eks_role.iam_role_name
}