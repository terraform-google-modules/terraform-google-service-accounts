module "service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 4.0"
  project_id = var.project_id
  names      = ["disabled-sa-1", "disabled-sa-2"]
  disabled   = true
}