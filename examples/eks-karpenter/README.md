<!-- BEGIN_TF_DOCS -->
# EKS Karpenter example
Deploy Karpenter to AWS EKS

```
terraform init
terraform plan
terraform apply
```
After deployment you can use Karpenter official documentation first use section to test autoscaling: https://karpenter.sh/v0.14.0/getting-started/getting-started-with-terraform/#first-use

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.7.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | ../../modules/eks-managed | n/a |
| <a name="module_karpenter"></a> [karpenter](#module\_karpenter) | ../../modules/eks-karpenter | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../../modules/simple-vpc | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->