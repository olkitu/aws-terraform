/**
* # Gitlab Runner in EKR
*
* Deploy Gitlab Runner to AWS EKR Cluster.
* 
* Example configuration:
* ```
* module "gitlab_runner" {
*   source = "https://github.com/olkitu/aws-terraform/tree/main/modules/eks-gitlab-runner"
*   
*   runnerRegisterationToken = "token"
* 
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

resource "kubernetes_namespace" "gitlab-runner" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "gitlab-runner" {
  metadata {
    name      = "gitlab-runner-eks"
    namespace = var.namespace
  }

  data = {
    accesskey = var.aws_access_key
    secretkey = var.aws_access_key_secret
  }
}

resource "local_file" "values_yaml" {
  content  = yamlencode(local.helm_chart_values)
  filename = "${path.module}/gitlab_values.yaml"
}

resource "helm_release" "gitlab-runner" {
  name             = local.name
  repository       = "https://charts.gitlab.io"
  chart            = "gitlab-runner"
  version          = var.version
  namespace        = kubernetes_namespace.gitlab-runner.name
  create_namespace = false

  values = [
    local_file.values_yaml.content
  ]

  depends_on = [kubernetes_secret.gitlab_runner]
}