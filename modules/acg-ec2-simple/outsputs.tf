output "autoscaling_group_arn" {
  value = module.acg.autoscaling_group_arn
}

output "autoscaling_group_name" {
  value = module.acg.autoscaling_group_name
}

output "iam_role_arn" {
  value = module.acg.iam_role_arn
}

output "launch_template_arn" {
  value = module.acg.launch_template_arn
}