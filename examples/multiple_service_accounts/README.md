# Multiple Service Accounts

This example illustrates how to use the `service-accounts` module to generate multiple service accounts.

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| project\_id | The ID of the project in which to provision resources. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| emails | The service account emails. |
| iam\_emails | The service account IAM-format emails. |
| keys | The service account keys. |

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
