locals {
  name   = var.name
  region = var.region

  tags = var.tags
}


variable "name" {
  type    = string
  default = "aws-demo"
}

variable "region" {
  default = "us-east-1"
}

variable "tags" {
  default = {
    ManagedBy = "Terraform"
  }
}

# EKS Variables
variable "eks_cluster_id" {}
variable "eks_cluster_endpoint" {}
variable "eks_cluster_certificate_authority_data" {}
variable "eks_oidc_provider_arn" {}
