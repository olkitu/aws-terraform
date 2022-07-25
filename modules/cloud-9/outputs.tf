output "id" {
  description = "Environment Id"
  value       = aws_cloud9_environment_ec2.cloud9_environment.id
}

output "arn" {
  description = "Environment Arn"
  value       = aws_cloud9_environment_ec2.cloud9_environment.arn
}

output "type" {
  description = "Environment Type"
  value       = aws_cloud9_environment_ec2.cloud9_environment.type
}

output "url" {
  description = "Cloud 9 Instance URL"
  value       = "https://${data.aws_region.current}.console.aws.amazon.com/cloud9/ide/${aws_cloud9_environment_ec2.cloud9_environment.id}"
}