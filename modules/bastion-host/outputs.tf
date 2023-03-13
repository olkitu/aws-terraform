# EC2
output "id" {
  description = "Instance ID"
  value       = module.ec2_bastion.id
}

output "arn" {
  description = "Instance ARN"
  value       = module.ec2_bastion.arn
}

output "public_ip" {
  description = "Bastion Host Public IP-address"
  value       = module.ec2_bastion.public_ip
}

output "public_dns" {
  description = "Bastion Host Public DNS address"
  value       = module.ec2_bastion.public_dns
}

# Security Group
output "security_group_id" {
  description = "Bastion Host Security Group"
  value       = module.ec2_bastion_sg.security_group_id
}