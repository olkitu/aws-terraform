/**
* # EKS Karpenter example
* Deploy Karpenter to AWS EKS
* 
* 
* ```
* terraform init
* terraform plan
* terraform apply
* ```
* After deployment you can use Karpenter official documentation first use section to test autoscaling: https://karpenter.sh/v0.14.0/getting-started/getting-started-with-terraform/#first-use
*/
module "vpc" {
  source = "../../modules/simple-vpc"

  name = local.name
  tags = local.tags
}

module "eks" {
  source = "../../modules/eks-managed"

  name = local.name
  tags = local.tags

  vpc_id         = module.vpc.vpc_id
  vpc_subnet_ids = module.vpc.private_subnets

  cluster_version = 1.23

  min_size     = 1
  max_size     = 1
  desired_size = 1
}

module "karpenter" {
  source = "../../modules/eks-karpenter"

  eks_cluster_id        = module.eks.cluster_id
  eks_cluster_endpoint  = module.eks.cluster_endpoint
  eks_oidc_provider_arn = module.eks.oidc_provider_arn

  karpenter_node_instance_role      = module.eks.node_group_amd64_iam_role_name
  karpenter_controller_iam_role_arn = module.eks.node_group_amd64_iam_role_arn
}