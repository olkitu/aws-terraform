<!-- BEGIN_TF_DOCS -->
# Elastic Kubernetes Service - Managed

Deploy EKS Cluster to AWS

```hcl
module "eks" {
  source = "github.com/olkitu/aws-terraform.git/modules/eks-managed"

  name = "aws-demo"

  vpc_id         = module.vpc.vpc_id
  vpc_subnet_ids = module.vpc.private_subnets
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.23.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.23.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 18.0 |

## Resources

| Name | Type |
|------|------|
| [aws_key_pair.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_kms_key.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.remote_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_capacity_type"></a> [capacity\_type](#input\_capacity\_type) | EKS Instance Capacity Type, SPOT or ON\_DEMAND | `string` | `"ON_DEMAND"` | no |
| <a name="input_cluster_endpoint_public_access_cidrs"></a> [cluster\_endpoint\_public\_access\_cidrs](#input\_cluster\_endpoint\_public\_access\_cidrs) | List of CIDR's to allow access to AWS EKS Public API | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_cluster_ip_family"></a> [cluster\_ip\_family](#input\_cluster\_ip\_family) | IPv4 or IPv6 to assigne pod and service address, default is ipv4. Changing this require replace resource. | `string` | `"ipv4"` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | EKS Cluster version | `number` | `1.23` | no |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | Desire size of nodes in EKS Cluster | `number` | `1` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Disk size of Managed EKS Instances | `number` | `20` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | List of amd64 supported instance types | `list(string)` | <pre>[<br/>  "t3.small",<br/>  "t3.medium"<br/>]</pre> | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Max amount of nodes in EKS Cluster | `number` | `5` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minium amount of nodes in EKS Cluster | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"aws-demo"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map` | <pre>{<br/>  "ManagedBy": "Terraform"<br/>}</pre> | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | VPC CIDR Block | `string` | `"10.0.0.0/8"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | VPC Subnets for EKS use | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Cluster Certificate Authority Data |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Cluster Endpoint |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | Cluster Id |
| <a name="output_node_group_amd64_iam_role_arn"></a> [node\_group\_amd64\_iam\_role\_arn](#output\_node\_group\_amd64\_iam\_role\_arn) | Node Group amd64 role arn |
| <a name="output_node_group_amd64_iam_role_name"></a> [node\_group\_amd64\_iam\_role\_name](#output\_node\_group\_amd64\_iam\_role\_name) | Node Groyup amd64 role name |
| <a name="output_oidc_provider"></a> [oidc\_provider](#output\_oidc\_provider) | Cluster OIDC Provider |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | Cluster OIDC Provider Arn |
<!-- END_TF_DOCS -->