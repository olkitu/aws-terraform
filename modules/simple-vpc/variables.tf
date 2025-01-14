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

variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "List of private subnets cidrs"
}

variable "public_subnets" {
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
  description = "List of public subnets cidrs"
}

variable "create_egress_only_igw" {
  type        = bool
  default     = true
  description = "Create IPv6 outgoing only Egress Only gateway"
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Enable NAT gateway"
}

variable "single_nat_gateway" {
  type        = bool
  default     = true
  description = "Single NAT gateway to save costs"
}

# VPC Flow Logs configuration
variable "enable_flow_log" {
  type        = bool
  default     = false
  description = "Enable or Disable VPC flow logs, default disabled"
}

variable "flow_log_file_format" {
  type        = string
  default     = "plain-text"
  description = "Flow Log file format"
}

variable "flow_log_destination_arn" {
  type        = string
  default     = null
  description = "ARN of the Cloudwatch group or S3 Bucket where VPC flow logs will be pushed"
}

variable "flow_log_destination_type" {
  type        = string
  default     = "cloud-watch-logs"
  description = "Destination type of flow logs, valid values are `s3`, `cloud-watch-logs` and `kinesis-data-firehose`"
}

variable "flow_log_cloudwatch_log_group_retention_in_days" {
  type        = number
  default     = 14
  description = "Specify days in number how long time keep logs"
}