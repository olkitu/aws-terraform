locals {
  tags = {
    ManagedBy = "Terraform"
  }
}

variable "name" {
  description = "Instance Name"
}

variable "instance_type" {
  description = "Cloud 9 Instance Type"
  default     = "t2.micro"
}

variable "automatic_stop_time_minutes" {
  description = "Shutdown inactive instance after minutes"
  default     = 30
  type        = number
}

variable "owner_arn" {
    description = "Owner Arn"
}