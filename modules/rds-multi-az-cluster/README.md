<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.23.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster"></a> [cluster](#module\_cluster) | terraform-aws-modules/rds-aurora/aws | 7.2.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | RDS Instance Allocated Storage | `number` | `10` | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Database Name | `string` | `"demodb"` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | Database Engine | `string` | `"mysql"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Database Engine version | `string` | `"8.0.27"` | no |
| <a name="input_family"></a> [family](#input\_family) | Database Family | `string` | `"mysql8.0"` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | Database Identifier | `string` | `"aws-demo"` | no |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | RDS DB Instance Class | `string` | `"db.t3.micro"` | no |
| <a name="input_major_engine_version"></a> [major\_engine\_version](#input\_major\_engine\_version) | Major Engine version | `string` | `"8.0"` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | RDS Instance Max Allocated Storage | `number` | `50` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"aws-demo"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"us-east-1"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map` | <pre>{<br/>  "ManagedBy": "Terraform"<br/>}</pre> | no |
| <a name="input_username"></a> [username](#input\_username) | RDS Instance Username | `string` | `"admin"` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | VPC CIDR Block | `string` | `"10.0.0.0/8"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | VPC Subnets for Bastion Host use | `list(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | Cluster Arn |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Cluster writer endpoint |
| <a name="output_cluster_master_password"></a> [cluster\_master\_password](#output\_cluster\_master\_password) | Cluster Master account password |
| <a name="output_cluster_master_username"></a> [cluster\_master\_username](#output\_cluster\_master\_username) | Cluster Master Username |
| <a name="output_cluster_port"></a> [cluster\_port](#output\_cluster\_port) | Cluster Port |
| <a name="output_cluster_reader_endpoint"></a> [cluster\_reader\_endpoint](#output\_cluster\_reader\_endpoint) | Cluster Reader endpoint |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Cluster Security Group Id |
<!-- END_TF_DOCS -->