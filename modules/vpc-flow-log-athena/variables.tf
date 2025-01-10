locals {
  name   = var.name
  region = var.region

  tags = var.tags


  ordered_partition_keys = [
    { key = "year", value = "string" },
    { key = "month", value = "string" },
  ]

  ordered_table_columns = [
    { key = "version", value = "int" },
    { key = "account_id", value = "string" },
    { key = "interface_id", value = "string" },
    { key = "srcaddr", value = "string" },
    { key = "dstaddr", value = "string" },
    { key = "srcport", value = "int" },
    { key = "dstport", value = "int" },
    { key = "protocol", value = "int" },
    { key = "packets", value = "bigint" },
    { key = "bytes", value = "bigint" },
    { key = "start", value = "bigint" },
    { key = "end", value = "bigint" },
    { key = "action", value = "string" },
    { key = "log_status", value = "string" },
  ]
}

variable "name" {
  type    = string
  default = "aws-demo"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "tags" {
  default = {
    ManagedBy = "Terraform"
  }
}

variable "workgroup_name" {
  type        = string
  description = "Athena workgroup name"
}

variable "s3_bucket_name" {
  type        = string
  description = "VPC Flow log S3 Bucket name"
}