/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  account_billing = var.grant_billing_role && var.billing_account_id != ""
  org_billing     = var.grant_billing_role && var.billing_account_id == "" && var.org_id != ""
  prefix          = var.prefix != "" ? "${var.prefix}-" : ""
  xpn             = var.grant_xpn_roles && var.org_id != ""
  emails          = [for account in google_service_account.service_accounts : account.email]
  iam_emails      = [for email in local.emails : "serviceAccount:${email}"]
}

# create service accounts
resource "google_service_account" "service_accounts" {
  count        = length(var.names)
  account_id   = "${local.prefix}${lower(element(var.names, count.index))}"
  display_name = "Terraform-managed service account"
  project      = var.project_id
}

# common roles
resource "google_project_iam_member" "project-roles" {
  count = length(var.project_roles) * length(var.names)

  project = element(
    split(
      "=>",
      element(var.project_roles, count.index % length(var.project_roles)),
    ),
    0,
  )

  role = element(
    split(
      "=>",
      element(var.project_roles, count.index % length(var.project_roles)),
    ),
    1,
  )

  member = "serviceAccount:${element(
    google_service_account.service_accounts.*.email,
    floor(count.index / length(var.project_roles)),
  )}"
}

# conditionally assign billing user role at the org level
resource "google_organization_iam_member" "billing_user" {
  count  = local.org_billing ? length(var.names) : 0
  org_id = var.org_id
  role   = "roles/billing.user"
  member = "serviceAccount:${google_service_account.service_accounts[count.index].email}"
}

# conditionally assign billing user role on a specific billing account
resource "google_billing_account_iam_member" "billing_user" {
  count              = local.account_billing ? length(var.names) : 0
  billing_account_id = var.billing_account_id
  role               = "roles/billing.user"
  member             = "serviceAccount:${google_service_account.service_accounts[count.index].email}"
}

# conditionally assign roles for shared VPC
# ref: https://cloud.google.com/vpc/docs/shared-vpc

resource "google_organization_iam_member" "xpn_admin" {
  count  = local.xpn ? length(var.names) : 0
  org_id = var.org_id
  role   = "roles/compute.xpnAdmin"
  member = "serviceAccount:${google_service_account.service_accounts[count.index].email}"
}

resource "google_organization_iam_member" "organization_viewer" {
  count  = local.xpn ? length(var.names) : 0
  org_id = var.org_id
  role   = "roles/resourcemanager.organizationViewer"
  member = "serviceAccount:${google_service_account.service_accounts[count.index].email}"
}

# keys
resource "google_service_account_key" "keys" {
  count              = var.generate_keys ? length(var.names) : 0
  service_account_id = google_service_account.service_accounts[count.index].email
}

