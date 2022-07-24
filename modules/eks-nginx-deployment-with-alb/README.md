## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.14.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.23.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks_cluster_certificate_authority_data"></a> [eks\_cluster\_certificate\_authority\_data](#input\_eks\_cluster\_certificate\_authority\_data) | EKS Cluster Certificate Data | `any` | n/a | yes |
| <a name="input_eks_cluster_endpoint"></a> [eks\_cluster\_endpoint](#input\_eks\_cluster\_endpoint) | EKS Cluster Endpoint | `any` | n/a | yes |
| <a name="input_eks_cluster_id"></a> [eks\_cluster\_id](#input\_eks\_cluster\_id) | EKS Cluster ID | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"aws-demo"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map` | <pre>{<br>  "ManagedBy": "Terraform"<br>}</pre> | no |

## Outputs

No outputs.
