output "eks_iam_role_arn" {
  description = "EKS Autoscale Role Arn"
  value       = module.iam_autoscale_eks_role.iam_role_arn
}

output "eks_iam_role_name" {
  description = "EKS Autoscale Role Name"
  value       = module.iam_autoscale_eks_role.iam_role_name
}