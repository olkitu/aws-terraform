<!-- BEGIN_TF_DOCS -->
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
| <a name="module_master"></a> [master](#module\_master) | terraform-aws-modules/rds/aws | 5.0.0 |
| <a name="module_replica"></a> [replica](#module\_replica) | terraform-aws-modules/rds/aws | 5.0.0 |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

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
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map` | <pre>{<br>  "ManagedBy": "Terraform"<br>}</pre> | no |
| <a name="input_username"></a> [username](#input\_username) | RDS Instance Username | `string` | `"admin"` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | VPC CIDR Block | `string` | `"10.0.0.0/8"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | VPC Subnets for Bastion Host use | `list(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_instance_address"></a> [db\_instance\_address](#output\_db\_instance\_address) | Database Instance Address |
| <a name="output_db_instance_arn"></a> [db\_instance\_arn](#output\_db\_instance\_arn) | Database Master Instance Arn |
| <a name="output_db_instance_ca_cert_identifier"></a> [db\_instance\_ca\_cert\_identifier](#output\_db\_instance\_ca\_cert\_identifier) | Database CA Certificate Identifier |
| <a name="output_db_instance_password"></a> [db\_instance\_password](#output\_db\_instance\_password) | Database Instance account password |
| <a name="output_db_instance_port"></a> [db\_instance\_port](#output\_db\_instance\_port) | Database Port |
| <a name="output_db_instance_username"></a> [db\_instance\_username](#output\_db\_instance\_username) | Database Instance account usename |
<!-- END_TF_DOCS -->