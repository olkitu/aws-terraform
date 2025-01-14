output "workgroup_name" {
  description = "Athena workgroup name"
  value       = aws_athena_workgroup.vpc_flow_logs.id
}

output "workgroup_arn" {
  description = "Athena workgroup ARN"
  value       = aws_athena_workgroup.vpc_flow_logs.arn
}

output "catalog_database_id" {
  description = "Glue Catalog Database Id and Name"
  value       = aws_glue_catalog_database.vpc_flow_logs.id
}

output "catalog_database_arn" {
  description = "Glue Catalog Database ARN"
  value       = aws_glue_catalog_database.vpc_flow_logs.arn
}

output "catalog_table_id" {
  description = "Glue Catalog Table Id and Name"
  value       = aws_glue_catalog_table.vpc_flow_logs.id
}

output "catalog_table_arn" {
  description = "Glue Catalog Table ARN"
  value       = aws_glue_catalog_table.vpc_flow_logs.arn
}

output "lambda_initial_partitioner" {
  description = "Lambda Initial Partitioner"
  value       = module.lambda_initial_partitioner
}

output "lambda_daily_partitioner" {
  description = "Lambda Daily Partitioner"
  value       = module.lambda_daily_partitioner
}

output "eventbridge_daily_partitioner" {
  description = "EventBridge Initial Partitioner"
  value       = module.eventbridge_daily_partitioner
}