<!-- BEGIN_TF_DOCS -->
# Gitlab Runner in EKR

Deploy Gitlab Runner to AWS EKR Cluster.

Example configuration:
```
module "gitlab_runner" {
  source = "https://github.com/olkitu/aws-terraform/tree/main/modules/eks-gitlab-runner"

  runnerRegisterationToken = "token"

  aws_access_key = module.iam_user.iam_access_key_id	
  aws_access_key_secret = module.iam_user.iam_access_key_secret

}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.23.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.5.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.10 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.23.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.5.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.10 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Resources

| Name | Type |
|------|------|
| [helm_release.gitlab-runner](https://registry.terraform.io/providers/hashicorp/helm/2.5.0/docs/resources/release) | resource |
| [kubernetes_namespace.gitlab-runner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.gitlab-runner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [local_file.values_yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS Access Key for shared cache | `string` | n/a | yes |
| <a name="input_aws_access_key_secret"></a> [aws\_access\_key\_secret](#input\_aws\_access\_key\_secret) | AWS Access Key Secret | `string` | n/a | yes |
| <a name="input_concurrent"></a> [concurrent](#input\_concurrent) | Gitlab Runner concurrent limit | `number` | `10` | no |
| <a name="input_cpu_arch"></a> [cpu\_arch](#input\_cpu\_arch) | CPU Architechture, amd64/arm64 | `string` | `"amd64"` | no |
| <a name="input_gitlabUrl"></a> [gitlabUrl](#input\_gitlabUrl) | Gitlab URL | `string` | `"https://gitlab.com"` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | `"aws-demo"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes Namespace name | `string` | `"gitlab-runner"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"us-east-1"` | no |
| <a name="input_runnerRegisterationToken"></a> [runnerRegisterationToken](#input\_runnerRegisterationToken) | Gitlab Registeration token | `string` | n/a | yes |
| <a name="input_runnerTags"></a> [runnerTags](#input\_runnerTags) | Runner Tags, list in string | `string` | `"kubernetes, cluster"` | no |
| <a name="input_s3_bucket_name"></a> [s3\_bucket\_name](#input\_s3\_bucket\_name) | S3 Bucket Name | `string` | n/a | yes |
| <a name="input_sentryDsn"></a> [sentryDsn](#input\_sentryDsn) | Sentry DSN | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map` | <pre>{<br>  "ManagedBy": "Terraform"<br>}</pre> | no |
<!-- END_TF_DOCS -->