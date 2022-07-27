/**
* # Example EKS Gitlab Runner
* 
* This will deploy
* * VPC
* * EKS Cluster with Autoscaler
* * S3 Bucket for runner cache
* * Gitlab Runner
* 
* ```
* terraform init
* terraform plan
* terraform apply
* ```
*/

module "vpc" {
  source = "../../modules/simple-vpc"

  name = local.name
  tags = local.tags
}

module "eks" {
  source = "../..//modules/eks-managed"

  name = local.name
  tags = local.tags

  vpc_id         = module.vpc.vpc_id
  vpc_subnet_ids = module.vpc.private_subnets
}

module "eks_autoscale" {
  source = "../..//modules/eks-autoscale"

  name = local.name
  tags = local.tags

  eks_cluster_id                         = module.eks.cluster_id
  eks_cluster_endpoint                   = module.eks.cluster_endpoint
  eks_cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data
  eks_oidc_provider_arn                  = module.eks.oidc_provider_arn
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.3.0"

  bucket = "${local.name}-cache-bucket"
  acl    = "private"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.tags
}

module "iam_assumable_role_with_oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.2.0"

  create_role = true

  role_name = "${local.name}-role"


  provider_url = module.eks.oidc_provider

  role_policy_arns = [
    module.iam_policy.arn,
  ]
  number_of_role_policy_arns = 1
}

module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.2.0"

  name        = "${local.name}-policy"
  description = "Allow Gitlab Runner access S3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:PutObject",
        "s3:GetObject",
        "s3:DeleteObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "${module.s3_bucket.s3_bucket_arn}",
        "${module.s3_bucket.s3_bucket_arn}/*"
      ]
    }
  ]
}
 EOF
}

module "gitlab_runner" {
  source = "../..//modules/eks-gitlab-runner"

  runner_registeration_token = var.runner_registeration_token

  name = local.name

  eks_cluster_id                         = module.eks.cluster_id
  eks_cluster_endpoint                   = module.eks.cluster_endpoint
  eks_cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data

  s3_bucket_name   = module.s3_bucket.s3_bucket_id
  s3_bucket_region = module.s3_bucket.s3_bucket_region

  runner_role_arn = module.iam_assumable_role_with_oidc.iam_role_arn
}