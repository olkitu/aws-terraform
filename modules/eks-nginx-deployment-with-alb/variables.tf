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
variable "eks_cluster_id" {
  description = "EKS Cluster ID"
}
variable "eks_cluster_endpoint" {
  description = "EKS Cluster Endpoint"
}
variable "eks_cluster_certificate_authority_data" {
  description = "EKS Cluster Certificate Data"
}