# Terraform Simple Service Account module

This submodule creates a service account and optionally grants specified roles on the project.

## Usage

Basic usage of this submodule is as follows:

```hcl
module "sa" {
  source  = "terraform-google-modules/service-accounts/google//modules/simple-sa"
  version = "~> 4.5"

  project_id    = "<PROJECT ID>"
  name          = "sa-name"
  project_roles = [
    "roles/compute.imageUser",
    "roles/compute.networkUser"
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| description | Default description of the created service accounts (defaults to no description) | `string` | `""` | no |
| display\_name | Display name of the created service accounts (defaults to 'Terraform-managed service account') | `string` | `"Terraform-managed service account"` | no |
| name | Name of service account | `string` | n/a | yes |
| project\_id | Project id where service account will be created | `string` | n/a | yes |
| project\_roles | Roles to grant the SA in specified project | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| account\_details | Service account id and email |
| email | Service account email |
| env\_vars | Exported environment variables |
| iam\_email | IAM format service account email |
| id | Service account id in the format 'projects/{{project}}/serviceAccounts/{{email}}' |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
