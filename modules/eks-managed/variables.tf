locals {
  name   = var.name
  region = var.region

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

variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

# Required Subnets
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  default     = "10.0.0.0/8"
}

variable "vpc_subnet_ids" {
  type        = list(string)
  description = "VPC Subnets for EKS use"
}

# EKS Configuration
variable "cluster_version" {
  type        = number
  description = "EKS Cluster version"
  default     = 1.23
}

variable "cluster_endpoint_public_access_cidrs" {
  type        = list(string)
  description = "List of CIDR's to allow access to AWS EKS Public API"
  default     = ["0.0.0.0/0"]
}

variable "cluster_ip_family" {
  type        = string
  default     = "ipv4"
  description = "IPv4 or IPv6 to assigne pod and service address, default is ipv4. Changing this require replace resource."
}

variable "instance_types" {
  type        = list(string)
  default     = ["t3.small", "t3.medium"]
  description = "List of amd64 supported instance types"
}

variable "disk_size" {
  type        = number
  default     = 20
  description = "Disk size of Managed EKS Instances"
}

variable "min_size" {
  type        = number
  default     = 1
  description = "Minium amount of nodes in EKS Cluster"
}

variable "max_size" {
  type        = number
  default     = 5
  description = "Max amount of nodes in EKS Cluster"
}

variable "desired_size" {
  type        = number
  default     = 1
  description = "Desire size of nodes in EKS Cluster"
}

variable "capacity_type" {
  default     = "ON_DEMAND"
  description = "EKS Instance Capacity Type, SPOT or ON_DEMAND"
}