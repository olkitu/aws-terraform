output "autoscaling_group_arn" {
  value = module.asg.autoscaling_group_arn
}

output "autoscaling_group_name" {
  value = module.asg.autoscaling_group_name
}

output "iam_role_arn" {
  value = module.asg.iam_role_arn
}

output "launch_template_arn" {
  value = module.asg.launch_template_arn
}