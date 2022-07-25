<!-- BEGIN_TF_DOCS -->
# Bastion Host

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.23.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ec2_bastion"></a> [ec2\_bastion](#module\_ec2\_bastion) | terraform-aws-modules/ec2-instance/aws | ~> 4.1.1 |
| <a name="module_ec2_bastion_sg"></a> [ec2\_bastion\_sg](#module\_ec2\_bastion\_sg) | terraform-aws-modules/security-group/aws//modules/ssh | 4.9.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ami_copy.amazon-linux-2-encrypted](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ami_copy) | resource |
| [aws_iam_instance_profile.instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.instance_profile_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.instance_profile_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_ami.amazon-linux-2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"aws-demo"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map` | <pre>{<br>  "ManagedBy": "Terraform"<br>}</pre> | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | VPC CIDR Block | `string` | `"10.0.0.0/8"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | VPC Subnets for Bastion Host use | `list(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_dns"></a> [public\_dns](#output\_public\_dns) | Bastion Host Public DNS address |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Bastion Host Public IP-address |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Bastion Host Security Group |
<!-- END_TF_DOCS -->