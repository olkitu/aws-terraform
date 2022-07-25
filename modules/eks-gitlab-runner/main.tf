/**
* # Gitlab Runner in EKS
*
* Deploy Gitlab Runner to AWS EKS Cluster.
* 
* ```hcl
* module "s3_bucket" {
*  source = "terraform-aws-modules/s3-bucket/aws"
*
*
*  bucket = "gitlab-runner-cache"
*  acl    = "private"
*
*  block_public_acls = true
*  block_public_policy = true
*  ignore_public_acls = true
*  restrict_public_buckets = true
*
*  server_side_encryption_configuration = {
*    rule = {
*      apply_server_side_encryption_by_default = {
*        sse_algorithm     = "AES256"
*      }
*    }
*  }
* }
*
* module "gitlab_runner" {
*   source = "github.com/olkitu/aws-terraform.git/modules/eks-gitlab-runner"
*   
*   runner_registeration_token = "token"
* 
*   eks_cluster_id = module.eks.cluster_id
*   eks_cluster_endpoint = module.eks.cluster_endpoint
*   eks_cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
* 
*   s3_bucket_name = module.s3_bucket.s3_bucket_id
*   s3_bucket_region = module.s3_bucket.s3_bucket_region
*   aws_access_key = module.iam_user.iam_access_key_id	
*   aws_access_key_secret = module.iam_user.iam_access_key_secret
*   
* }
* ```
*/
data "aws_region" "current" {}

provider "kubernetes" {
  host                   = var.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(var.eks_cluster_certificate_authority_data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_id]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes {
    host                   = var.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(var.eks_cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_id]
      command     = "aws"
    }
  }
}

resource "kubernetes_namespace" "gitlab-runner" {
  metadata {
    name = var.eks_namespace
  }
}

resource "kubernetes_secret" "gitlab-runner" {
  metadata {
    name      = "${local.name}-cache-access"
    namespace = var.eks_namespace
  }

  data = {
    accesskey = var.aws_access_key
    secretkey = var.aws_access_key_secret
  }

  type = "generic"

  depends_on = [kubernetes_namespace.gitlab-runner]
}

resource "local_file" "values_yaml" {
  content  = yamlencode(local.helm_chart_values)
  filename = "${path.module}/gitlab_values.yaml"
}

resource "helm_release" "gitlab-runner" {
  name             = local.name
  repository       = "https://charts.gitlab.io"
  chart            = "gitlab-runner"
  version          = var.runner_version
  namespace        = var.eks_namespace
  create_namespace = false

  values = [
    local_file.values_yaml.content
  ]

  depends_on = [kubernetes_secret.gitlab-runner]
}