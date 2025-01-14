locals {
  name = var.name

  tags = var.tags

  current_timestamp = timestamp()
  year              = formatdate("YYYY", local.current_timestamp)
  month             = formatdate("MM", local.current_timestamp)
  day               = formatdate("DD", local.current_timestamp)
  timedate          = formatdate("DD-MMM-YYYYZhh:mm", local.current_timestamp)

  partition_start_date = var.partition_start_date != "" ? var.partition_start_date : local.timedate

  ordered_partition_keys = [
    { key = "year", value = "string" },
    { key = "month", value = "string" },
    { key = "day", value = "string" }
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

  lambda_policy_json = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "glue:GetTable",
          "glue:CreatePartition",
          "glue:UpdatePartition",
          "glue:GetPartition"
        ]
        Resource = [
          "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:catalog/*",
          "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:database/${local.name}",
          "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:catalog",
          "arn:aws:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/${local.name}/${var.glue_catalog_table_name}"
        ]
      }
    ]
  })
}

variable "name" {
  type        = string
  description = "Name of project"
  default     = "aws-demo"
}

variable "tags" {
  type = map(string)
  default = {
    ManagedBy = "Terraform"
  }
}

variable "workgroup_name" {
  type        = string
  description = "Athena workgroup name"
}

variable "glue_catalog_table_name" {
  type        = string
  description = "Glue Catalog Table name"
  default     = "vpc_flow_logs"
}

variable "s3_bucket_name" {
  type        = string
  description = "VPC Flow log S3 Bucket name"
}

variable "force_destroy" {
  type        = bool
  description = "Force destroy? default: false"
  default     = false
}

variable "partition_start_date" {
  type    = string
  default = ""
}