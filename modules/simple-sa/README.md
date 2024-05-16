# Terraform Simple Service Account module

This submodule creates a service account and optionally grants specified roles on the project.

## Usage

Basic usage of this submodule is as follows:

```hcl
module "sa" {
  source  = "terraform-google-modules/service-accounts/google//modules/simple-sa"
  version = "~> 4.3"

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
| project\_roles | Roles to grant the SA in specified project | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| email | Service account email |
| id | Service account id and email |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
