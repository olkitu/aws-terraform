locals {
  name   = var.name
  region = var.region

  tags = var.tags


  engine                = var.engine
  engine_version        = var.engine_version
  family                = var.family               # DB parameter group
  major_engine_version  = var.major_engine_version # DB option group
  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  port                  = 3306
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


## VPC
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  default     = "10.0.0.0/8"
}

variable "vpc_subnet_ids" {
  type        = list(any)
  description = "VPC Subnets for Bastion Host use"
}

#DB Config

variable "identifier" {
  description = "Database Identifier"
  default     = "aws-demo"
}

variable "db_name" {
  description = "Database Name"
  default     = "demodb"

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9_]{0,39}$", var.db_name))
    error_message = "DBName must begin with a letter and contain only alphanumeric characters"
  }
}

variable "engine" {
  description = "Database Engine"
  default     = "mysql"
}

variable "engine_version" {
  description = "Database Engine version"
  default     = "8.0.27"
}

variable "family" {
  description = "Database Family"
  default     = "mysql8.0"

}

variable "major_engine_version" {
  description = "Major Engine version"
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS DB Instance Class"
  default     = "db.t3.micro"
}

variable "username" {
  description = "RDS Instance Username"
  default     = "admin"
}

variable "allocated_storage" {
  description = "RDS Instance Allocated Storage"
  default     = 10
  type        = number
}

variable "max_allocated_storage" {
  description = "RDS Instance Max Allocated Storage"
  default     = 50
  type        = number
}