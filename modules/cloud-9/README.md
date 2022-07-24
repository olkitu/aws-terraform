## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloud9_environment_ec2.cloud9_environment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloud9_environment_ec2) | resource |
| [aws_instance.cloud9_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instance) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_automatic_stop_time_minutes"></a> [automatic\_stop\_time\_minutes](#input\_automatic\_stop\_time\_minutes) | Shutdown inactive instance after minutes | `number` | `30` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Cloud 9 Instance Type | `string` | `"t2.micro"` | no |
| <a name="input_name"></a> [name](#input\_name) | Instance Name | `any` | n/a | yes |
| <a name="input_owner_arn"></a> [owner\_arn](#input\_owner\_arn) | Owner Arn | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Environment Arn |
| <a name="output_id"></a> [id](#output\_id) | Environment Id |
| <a name="output_type"></a> [type](#output\_type) | Environment Type |
| <a name="output_url"></a> [url](#output\_url) | Cloud 9 Instance URL |
