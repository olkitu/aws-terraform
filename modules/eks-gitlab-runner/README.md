<!-- BEGIN_TF_DOCS -->
# Gitlab Runner in EKS

Deploy Gitlab Runner to AWS EKS Cluster.

```hcl
module "s3_bucket" {
 source = "terraform-aws-modules/s3-bucket/aws"

 bucket = "gitlab-runner-cache"
 acl    = "private"

 block_public_acls = true
 block_public_policy = true
 ignore_public_acls = true
 restrict_public_buckets = true

 server_side_encryption_configuration = {
   rule = {
     apply_server_side_encryption_by_default = {
       sse_algorithm     = "AES256"
     }
   }
 }
}

module "iam_assumable_role_with_oidc" {
 source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

 create_role = true

 role_name = "gitlab-runner-role"

 provider_url = module.eks.oidc_provider

 role_policy_arns = [
   module.iam_policy.arn,
 ]
 number_of_role_policy_arns = 1
}

module "iam_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name = "gitlab-runner-policy"
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
  source = "github.com/olkitu/aws-terraform.git/modules/eks-gitlab-runner"

  runner_registeration_token = "token"

  eks_cluster_id = module.eks.cluster_id
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_cluster_certificate_authority_data = module.eks.cluster_certificate_authority_data

  s3_bucket_name = module.s3_bucket.s3_bucket_id
  s3_bucket_region = module.s3_bucket.s3_bucket_region

  runner_role_arn = module.iam_assumable_role_with_oidc.iam_role_arn
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.23.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.5.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.23.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.5.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.10 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.gitlab-runner](https://registry.terraform.io/providers/hashicorp/helm/2.5.0/docs/resources/release) | resource |
| [kubernetes_namespace.gitlab-runner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [local_file.values_yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capacity_type"></a> [capacity\_type](#input\_capacity\_type) | Capacity Type, ON\_DEMAND or SPOT | `string` | `"SPOT"` | no |
| <a name="input_cpu_arch"></a> [cpu\_arch](#input\_cpu\_arch) | CPU Architechture, amd64/arm64 | `string` | `"amd64"` | no |
| <a name="input_eks_cluster_certificate_authority_data"></a> [eks\_cluster\_certificate\_authority\_data](#input\_eks\_cluster\_certificate\_authority\_data) | EKS Cluster Certificate Data | `any` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS Cluster Endpoint | `any` | n/a | yes |
| <a name="input_eks_cluster_id"></a> [eks\_cluster\_id](#input\_eks\_cluster\_id) | EKS Cluster ID | `any` | n/a | yes |
| <a name="input_eks_namespace"></a> [eks\_namespace](#input\_eks\_namespace) | Kubernetes Namespace name | `string` | `"gitlab-runner"` | no |
| <a name="input_gitlab_url"></a> [gitlab\_url](#input\_gitlab\_url) | Gitlab URL | `string` | `"https://gitlab.com"` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"aws-demo"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Regon | `string` | `"us-east-1"` | no |
| <a name="input_runner_concurrent"></a> [runner\_concurrent](#input\_runner\_concurrent) | Gitlab Runner concurrent limit | `number` | `10` | no |
| <a name="input_runner_registeration_token"></a> [runner\_registeration\_token](#input\_runner\_registeration\_token) | Gitlab Registeration token | `string` | n/a | yes |
| <a name="input_runner_role_arn"></a> [runner\_role\_arn](#input\_runner\_role\_arn) | AWS Access Key for shared cache | `string` | n/a | yes |
| <a name="input_runner_sentry_dsn"></a> [runner\_sentry\_dsn](#input\_runner\_sentry\_dsn) | Sentry DSN | `string` | `""` | no |
| <a name="input_runner_tags"></a> [runner\_tags](#input\_runner\_tags) | Runner Tags, list in string | `string` | `"kubernetes, cluster"` | no |
| <a name="input_runner_version"></a> [runner\_version](#input\_runner\_version) | Gitlab Runner Helm Chart version | `string` | `"0.41.0"` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | S3 Bucket Name | `string` | n/a | yes |
| <a name="input_s3_bucket_region"></a> [s3\_bucket\_region](#input\_s3\_bucket\_region) | S3 Bucket Region | `string` | `"us-east-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map` | <pre>{<br>  "ManagedBy": "Terraform"<br>}</pre> | no |
<!-- END_TF_DOCS -->