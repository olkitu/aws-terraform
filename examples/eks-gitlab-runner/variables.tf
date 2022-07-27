locals {
  name = "truongfi-gr-demo"
  tags = {
    ManagedBy = "Terraform"
  }
}

variable "runner_registeration_token" {
  description = "Gitlab Runner Registeration Token"
  type        = string
  sensitive   = true
}