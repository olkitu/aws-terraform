locals {
  name = var.name
  tags = var.tags
}

variable "name" {
  type    = string
  default = "aws-demo"
}

variable "tags" {
  default = {
    ManagedBy = "Terraform"
  }
}

variable "eks_cluster_id" {
  description = "EKS Cluster ID"
}
variable "eks_cluster_endpoint" {
  description = "EKS Cluster Endpoint"
}
variable "eks_oidc_provider_arn" {
  description = "EKS OIDC Provider Arn"
}

variable "karpenter_controller_iam_role_arn" {
  description = "Karpenter Controller Node IAM Role Arn"
}

variable "karpenter_node_instance_role" {
  description = "Karpenter Instance Role Arn"
}