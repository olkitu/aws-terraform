# Secure RDS Connection via Bastion Host

Using Session Manager port forwarding feature no need expose any ports to internet. With IAM Authentication all events logged to CloudTrail.

Deploy this example using terraform:
```
terraform plan
terraform apply
```

After successful deployment you can use script to connect to database.
`bash connect-to-rds.sh`

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.23.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ../../modules/bastion-host | n/a |
| <a name="module_rds-instance"></a> [rds-instance](#module\_rds-instance) | ../../modules/rds-multi-az-instance | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../../modules/simple-vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | Current AWS Region |
| <a name="output_bastion_id"></a> [bastion\_id](#output\_bastion\_id) | Bastion Instance ID |
| <a name="output_rds_address"></a> [rds\_address](#output\_rds\_address) | RDS Instance Address |
| <a name="output_rds_password"></a> [rds\_password](#output\_rds\_password) | RDS Instance admin user password |
| <a name="output_rds_port"></a> [rds\_port](#output\_rds\_port) | RDS Instance Port |
| <a name="output_rds_username"></a> [rds\_username](#output\_rds\_username) | RDS Instance admin username |
