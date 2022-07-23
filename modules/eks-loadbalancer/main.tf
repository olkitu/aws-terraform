# https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html
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

module "iam_loadbalancer_eks_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~>4.21.0"

  role_name        = "${local.name}-iam-lb-eks-role"
  role_description = "Load Balancer Policy for EKS"

  attach_load_balancer_controller_policy = true

  cluster_autoscaler_cluster_ids = [var.eks_cluster_id]


  oidc_providers = {
    main = {
      provider_arn               = var.eks_oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  tags = local.tags
}


resource "kubernetes_service_account" "cluster_loadbalancer" {
  metadata {
    name        = local.serviceAccountName
    namespace   = "kube-system"
    labels      = { k8s-addon = "cluster-loadbalancer.addons.k8s.io", k8s-app = "cluster-loadbalancer" }
    annotations = { "eks.amazonaws.com/role-arn" = module.iam_loadbalancer_eks_role.iam_role_arn }
  }
}

resource "kubernetes_cluster_role" "cluster_loadbalancer" {
  metadata {
    name   = "cluster-loadbalancer"
    labels = { k8s-addon = "cluster-loadbalancer.addons.k8s.io", k8s-app = "cluster-loadbalancer" }
  }
}

resource "helm_release" "loadbalancer" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  set {
    name  = "clusterName"
    value = var.eks_cluster_id
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = local.serviceAccountName
  }
}