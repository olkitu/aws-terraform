locals {
  name = "aws-runner-demo"
  tags = {
    ManagedBy = "Terraform"
  }
}

variable "runner_registeration_token" {
  description = "Gitlab Runner Registeration Token"
  type        = string
  sensitive   = true
}