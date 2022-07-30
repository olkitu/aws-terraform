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


variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "vpc_zone_identifier" {
  type        = list(string)
  description = "VPC Subnets"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  default     = "10.0.0.0/8"
}

# Autoscalegroup variables
variable "instance_type" {
  type        = string
  default     = "t3.small"
  description = "Instance Type"
}

variable "volume_size" {
  type        = number
  default     = 20
  description = "Disk size of EC2 Instances"
}

variable "min_size" {
  type        = number
  default     = 1
  description = "Minium amount EC2 Instances"
}

variable "max_size" {
  type        = number
  default     = 2
  description = "Max amount of EC2 Instances"
}