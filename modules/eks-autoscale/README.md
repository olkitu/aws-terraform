## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.23.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.10 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_autoscale_eks_role"></a> [iam\_autoscale\_eks\_role](#module\_iam\_autoscale\_eks\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | ~>4.21.0 |

## Resources

| Name | Type |
|------|------|
| [kubernetes_cluster_role.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role) | resource |
| [kubernetes_cluster_role_binding.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_deployment.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) | resource |
| [kubernetes_role.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role) | resource |
| [kubernetes_role_binding.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_binding) | resource |
| [kubernetes_service_account.cluster_autoscaler](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks_cluster_certificate_authority_data"></a> [eks\_cluster\_certificate\_authority\_data](#input\_eks\_cluster\_certificate\_authority\_data) | n/a | `any` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | n/a | `any` | n/a | yes |
| <a name="input_eks_cluster_id"></a> [eks\_cluster\_id](#input\_eks\_cluster\_id) | EKS Variables | `any` | n/a | yes |
| <a name="input_eks_oidc_provider_arn"></a> [eks\_oidc\_provider\_arn](#input\_eks\_oidc\_provider\_arn) | n/a | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"aws-demo"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map` | <pre>{<br>  "ManagedBy": "Terraform"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_iam_role_arn"></a> [eks\_iam\_role\_arn](#output\_eks\_iam\_role\_arn) | n/a |
| <a name="output_eks_iam_role_name"></a> [eks\_iam\_role\_name](#output\_eks\_iam\_role\_name) | n/a |
