<!-- BEGIN_TF_DOCS -->
# Example EKS Gitlab Runner

This will deploy
* VPC
* EKS Cluster with Autoscaler
* S3 Bucket for runner cache
* Gitlab Runner

```
terraform init
terraform plan
terraform apply
```

## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | ../..//modules/eks-managed | n/a |
| <a name="module_eks_autoscale"></a> [eks\_autoscale](#module\_eks\_autoscale) | ../..//modules/eks-autoscale | n/a |
| <a name="module_gitlab_runner"></a> [gitlab\_runner](#module\_gitlab\_runner) | ../..//modules/eks-gitlab-runner | n/a |
| <a name="module_iam_assumable_role_with_oidc"></a> [iam\_assumable\_role\_with\_oidc](#module\_iam\_assumable\_role\_with\_oidc) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | n/a |
| <a name="module_iam_policy"></a> [iam\_policy](#module\_iam\_policy) | terraform-aws-modules/iam/aws//modules/iam-policy | n/a |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../../modules/simple-vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_runner_registeration_token"></a> [runner\_registeration\_token](#input\_runner\_registeration\_token) | Gitlab Runner Registeration Token | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->