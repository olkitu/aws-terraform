locals {
  name   = var.name
  region = var.region

  tags = var.tags
}


variable "name" {
  type    = string
  default = "aws-vpc"
}

variable "region" {
  default = "us-east-1"
}

variable "tags" {
  default = {
    ManagedBy = "Terraform"
  }
}

variable "cidr" {
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "create_egress_only_igw" {
  type        = bool
  default     = true
  description = "Create IPv6 outgoing only Egress Only gateway"
}