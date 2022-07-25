/**
* # Nginx deployment with ALB to EKS
* 
* This requires first deploy AWS Load Balancer Controller Add-on to EKS.
*
* ```
* module "eks_loadbalancer" {
*   source = "github.com/olkitu/aws-terraform.git/modules/eks-loadbalancer"
*
*   name = "aws-demo"
*
*   eks_cluster_id                         = module.eks.cluster_id
*   eks_cluster_endpoint                   = module.eks.cluster_endpoint
*   eks_cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
*   eks_oidc_provider_arn                  = module.eks.oidc_provider_arn
* }
*
* module "eks_nginx" {
*   source = "github.com/olkitu/aws-terraform.git/modules/eks-test-app"
*
*   name = "aws-demo"
*
*   eks_cluster_id                         = module.eks.cluster_id
*   eks_cluster_endpoint                   = module.eks.cluster_endpoint
*   eks_cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
* }
* ``` 
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

resource "kubernetes_service_v1" "nginx" {
  metadata {
    name = "nginx"
    labels = {
      app = kubernetes_deployment_v1.nginx.metadata.0.labels.app
    }
  }
  spec {
    selector = {
      app = "nginx"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}

resource "kubernetes_ingress_v1" "nginx" {
  metadata {
    name = "nginx"
    # Possible Incgress annotations: https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/guide/ingress/annotations/
    annotations = {
      "kubernetes.io/ingress.class"               = "alb"
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"     = "ip"
      "alb.ingress.kubernetes.io/ip-address-type" = "dualstack"
    }
  }
  spec {
    default_backend {
      service {
        name = "nginx"
        port {
          number = 80
        }
      }
    }
  }
}
resource "kubernetes_deployment_v1" "nginx" {
  metadata {
    name = "nginx"
    labels = {
      app = "nginx"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app" = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          image = "nginx:stable"
          name  = "nginx"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}