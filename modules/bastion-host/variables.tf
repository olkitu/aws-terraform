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
  default     = "us-east-1"
  description = "AWS Region"
}

variable "tags" {
  default = {
    ManagedBy = "Terraform"
  }
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "vpc_subnet_ids" {
  type        = list(any)
  description = "VPC Subnets for Bastion Host use"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  default     = "10.0.0.0/8"
}