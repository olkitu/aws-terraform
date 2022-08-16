/**
* # EKS Karpenter
* 
* Enable EKS up and down autoscaling to meet changing demands.
*/

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

provider "kubectl" {
  apply_retry_count      = 5
  host                   = var.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(var.eks_cluster_certificate_authority_data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_id]
  }
}

data "aws_partition" "current" {}
data "aws_region" "current" {}


module "iam_karpenter_eks_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~>5.0.0"

  role_name        = "${local.name}-${data.aws_region.current.name}-iam_karpenter_eks_role"
  role_description = "Karpenter Policy for EKS"

  attach_karpenter_controller_policy = true

  karpenter_tag_key               = "karpenter.sh/discovery/${local.name}"
  karpenter_controller_cluster_id = var.eks_cluster_id
  karpenter_controller_node_iam_role_arns = [
    var.karpenter_controller_iam_role_arn
  ]

  oidc_providers = {
    main = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = ["karpenter:karpenter"]
    }
  }

  tags = local.tags
}

resource "aws_iam_instance_profile" "karpenter" {
  name = "${local.name}-KarpenterNodeInstanceProfile"
  role = var.karpenter_node_instance_role
}

resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = "v0.14.0"

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_karpenter_eks_role.iam_role_arn
  }

  set {
    name  = "clusterName"
    value = var.eks_cluster_id
  }

  set {
    name  = "clusterEndpoint"
    value = var.eks_cluster_endpoint
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter.name
  }
}


resource "kubectl_manifest" "karpenter_provisioner" {
  yaml_body = <<-YAML
  apiVersion: karpenter.sh/v1alpha5
  kind: Provisioner
  metadata:
    name: default
  spec:
    requirements:
      - key: karpenter.sh/capacity-type
        operator: In
        values: ["spot"]
      - key: kubernetes.io/arch
        operator: In
        values: ["amd64", "arm64"]
      - key: karpenter.k8s.aws/instance-category
        operator: In
        values: ["t"]
    limits:
      resources:
        cpu: 1000
    provider:
      subnetSelector:
        Name: "*private*"
      securityGroupSelector:
        karpenter.sh/discovery/${var.eks_cluster_id}: ${var.eks_cluster_id}
      tags:
        karpenter.sh/discovery/${var.eks_cluster_id}: ${var.eks_cluster_id}
    ttlSecondsAfterEmpty: 30
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}