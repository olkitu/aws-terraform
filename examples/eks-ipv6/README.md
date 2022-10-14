<!-- BEGIN_TF_DOCS -->
# Example EKS with IPv6 only

This will deploy
* VPC with IPv4+IPv6 Dual Stack
* EKS with IPv6 only

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
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../../modules/simple-vpc | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->