<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eventbridge_daily_partitioner"></a> [eventbridge\_daily\_partitioner](#module\_eventbridge\_daily\_partitioner) | terraform-aws-modules/eventbridge/aws | 3.14.2 |
| <a name="module_lambda_daily_partitioner"></a> [lambda\_daily\_partitioner](#module\_lambda\_daily\_partitioner) | terraform-aws-modules/lambda/aws | 7.20.0 |
| <a name="module_lambda_initial_partitioner"></a> [lambda\_initial\_partitioner](#module\_lambda\_initial\_partitioner) | terraform-aws-modules/lambda/aws | 7.20.0 |

## Resources

| Name | Type |
|------|------|
| [aws_athena_named_query.VpcFlowLogsAdminPortTraffic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_named_query) | resource |
| [aws_athena_named_query.VpcFlowLogsSshRdpTraffic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_named_query) | resource |
| [aws_athena_named_query.VpcFlowLogsTopRejects](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_named_query) | resource |
| [aws_athena_named_query.VpcFlowLogsTotalBytesTransferred](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_named_query) | resource |
| [aws_athena_workgroup.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_workgroup) | resource |
| [aws_glue_catalog_database.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database) | resource |
| [aws_glue_catalog_table.vpc_flow_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_table) | resource |
| [aws_lambda_invocation.initial_partitioner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Force destroy? default: false | `bool` | `false` | no |
| <a name="input_glue_catalog_table_name"></a> [glue\_catalog\_table\_name](#input\_glue\_catalog\_table\_name) | Glue Catalog Table name | `string` | `"vpc_flow_logs"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of project | `string` | `"aws-demo"` | no |
| <a name="input_partition_start_date"></a> [partition\_start\_date](#input\_partition\_start\_date) | n/a | `string` | `""` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | VPC Flow log S3 Bucket name | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br/>  "ManagedBy": "Terraform"<br/>}</pre> | no |
| <a name="input_workgroup_name"></a> [workgroup\_name](#input\_workgroup\_name) | Athena workgroup name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_catalog_database_arn"></a> [catalog\_database\_arn](#output\_catalog\_database\_arn) | Glue Catalog Database ARN |
| <a name="output_catalog_database_id"></a> [catalog\_database\_id](#output\_catalog\_database\_id) | Glue Catalog Database Id and Name |
| <a name="output_catalog_table_arn"></a> [catalog\_table\_arn](#output\_catalog\_table\_arn) | Glue Catalog Table ARN |
| <a name="output_catalog_table_id"></a> [catalog\_table\_id](#output\_catalog\_table\_id) | Glue Catalog Table Id and Name |
| <a name="output_eventbridge_daily_partitioner"></a> [eventbridge\_daily\_partitioner](#output\_eventbridge\_daily\_partitioner) | EventBridge Initial Partitioner |
| <a name="output_lambda_daily_partitioner"></a> [lambda\_daily\_partitioner](#output\_lambda\_daily\_partitioner) | Lambda Daily Partitioner |
| <a name="output_lambda_initial_partitioner"></a> [lambda\_initial\_partitioner](#output\_lambda\_initial\_partitioner) | Lambda Initial Partitioner |
| <a name="output_workgroup_arn"></a> [workgroup\_arn](#output\_workgroup\_arn) | Athena workgroup ARN |
| <a name="output_workgroup_name"></a> [workgroup\_name](#output\_workgroup\_name) | Athena workgroup name |
<!-- END_TF_DOCS -->