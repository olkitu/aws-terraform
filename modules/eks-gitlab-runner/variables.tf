locals {
  name   = var.name
  region = var.region
  tags   = var.tags

  helm_chart_values = {
    "unregisterRunners"       = true,
    "imagePullPolicy"         = "Always",
    "gitlabUrl"               = var.gitlab_url,
    "runnerRegistrationToken" = var.runner_registeration_token,
    "concurrent"              = var.runner_concurrent,
    "rbac" = {
      "create" : true
    },
    "sentryDsn" = "${var.runner_sentry_dsn}",
    "runners" = {
      "config" : <<EOF
        [[runners]]
          [runners.kubernetes]
            image = "debian:stable-slim"
            privileged = true
            namespace = "${var.eks_namespace}"
            cpu_limit = "500m"
            cpu_limit_overwrite_max_allowed = "2"
            cpu_request = "300m"
            cpu_request_overwrite_max_allowed = "2"
            memory_limit = "4096Mi"
            memory_limit_overwrite_max_allowed = "8192Mi"
            memory_request = "1024Mi"
            memory_request_overwrite_max_allowed = "8Gi"
            service_cpu_limit = "2"
            service_cpu_request = "0.5"
            service_memory_limit = "8Gi"
            service_memory_request = "500Mi"
            helper_cpu_limit = "2"
            helper_cpu_request = "0.5"
            helper_memory_limit = "2048Mi"
            helper_memory_request = "500Mi"
            ephemeral_storage_limit = "2000Mi"
            ephemeral_storage_request = "500Mi"
            ephemeral_storage_limit_overwrite_max_allowed = "10Gi"
            helper_ephemeral_storage_limit = "500Mi"
            helper_ephemeral_storage_limit_overwrite_max_allowed = "1000Mi"
            helper_ephemeral_storage_request = "1Mi"
            service_ephemeral_storage_limit = "500Mi"
            service_ephemeral_storage_limit_overwrite_max_allowed = "1000Mi"
            service_ephemeral_storage_request = "1Mi"
            poll_timeout = 300
          [runners.kubernetes.node_selector]
            "kubernetes.io/arch" = "${var.cpu_arch}"
            "kubernetes.io/os" = "linux"
          [[runners.kubernetes.volumes.empty_dir]]
            name = "docker-certs"
            mount_path = "/certs/client"
            medium = "Memory"
          [runners.cache]
            Type = "s3"
            Path = "cache"
            Shared = true
            [runners.cache.s3]
              ServerAddress = "s3.amazonaws.com"
              BucketName = "${var.s3_bucket_name}"
              BucketLocation = "${var.s3_bucket_region}"
              AuthenticationType = "access-key"
        EOF
      "tags" : "${var.runner_tags}, ${var.cpu_arch}",
      "runUntagged" : false,
      "secret" : "gitlab-registry-secret"
      "cache" : {
        "secretName" : "${kubernetes_secret.gitlab-runner.metadata.0.name}"
      }
    }
  }
}


variable "name" {
  type    = string
  default = "aws-demo"
}

variable "region" {
  description = "AWS Regon"
  default     = "us-east-1"
}

variable "tags" {
  default = {
    ManagedBy = "Terraform"
  }
}

# EKS Variables
variable "eks_cluster_id" {
  description = "EKS Cluster ID"
}
variable "eks_cluster_endpoint" {
  description = "EKS Cluster Endpoint"
}
variable "eks_cluster_certificate_authority_data" {
  description = "EKS Cluster Certificate Data"
}

variable "eks_namespace" {
  description = "Kubernetes Namespace name"
  default     = "gitlab-runner"
}

# Gitlab Runners configuration

variable "runner_version" {
  description = "Gitlab Runner Helm Chart version"
  default     = "0.41.0"
}

variable "gitlab_url" {
  description = "Gitlab URL"
  default     = "https://gitlab.com"
}

variable "runner_registeration_token" {
  description = "Gitlab Registeration token"
  type        = string
  sensitive   = true
}

variable "runner_concurrent" {
  description = "Gitlab Runner concurrent limit"
  default     = 10
}

variable "runner_sentry_dsn" {
  description = "Sentry DSN"
  type        = string
  default     = ""
}

variable "runner_tags" {
  type        = string
  description = "Runner Tags, list in string"
  default     = "kubernetes, cluster"
}

variable "cpu_arch" {
  description = "CPU Architechture, amd64/arm64"
  default     = "amd64"
}

# S3 Bucket for caching
variable "s3_bucket_name" {
  description = "S3 Bucket Name"
  type        = string
}

variable "s3_bucket_region" {
  description = "S3 Bucket Region"
  type = string
  default = "us-east-1"
}

# IAM User Access Keys for S3 shared cache access
variable "aws_access_key" {
  description = "AWS Access Key for shared cache"
  type        = string
}

variable "aws_access_key_secret" {
  description = "AWS Access Key Secret"
  type        = string
  sensitive   = true
}