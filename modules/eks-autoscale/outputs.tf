output "eks_iam_role_arn" {
  value = module.iam_autoscale_eks_role.iam_role_arn
}

output "eks_iam_role_name" {
  value = module.iam_autoscale_eks_role.iam_role_name
}