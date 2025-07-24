module "service_accounts" {
  source     = "terraform-google-modules/service-accounts/google"
  version    = "~> 4.0"
  project_id = var.project_id
  names      = ["disabled-sa-1", "enabled-sa-2"]
  disabled = {
    "disabled-sa-1" = true
    "enabled-sa-2"  = false
  }
}
