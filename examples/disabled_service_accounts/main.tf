module "service_accounts" {
  source     = "../../"
  project_id = var.project_id
  names      = ["disabled-sa-1", "disabled-sa-2"]
  disabled   = true
}

output "is_disabled" {
  value = module.service_accounts.disabled
}
