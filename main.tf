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
  account_billing       = "${var.grant_billing_role && var.billing_account_id != ""}"
  org_billing           = "${var.grant_billing_role && var.billing_account_id == "" && var.org_id != ""}"
  billing_account_roles = "${local.account_billing ? "${var.billing_account_id}=>roles/billing.user" : ""}"
  billing_org_role      = "${local.org_billing ? "${var.org_id}=>roles/billing.user" : ""}"
  org_roles             = "${compact(distinct(concat(var.org_roles, list(local.billing_org_role), list(local.org_roles_xpn1), list(local.org_roles_xpn2))))}"
  account_roles_billing = "${compact(distinct(concat(var.org_roles, list(local.billing_org_role))))}"
  org_roles_xpn1        = "${local.xpn ? "${var.org_id}=>roles/compute.xpnAdmin" : ""}"
  org_roles_xpn2        = "${local.xpn ? "${var.org_id}=>roles/resourcemanager.organizationViewer" : ""}"
  prefix                = "${var.prefix != "" ? "${var.prefix}-" : ""}"
  xpn                   = "${var.grant_xpn_roles && var.org_id != ""}"
}

# create service accounts
resource "google_service_account" "service_accounts" {
  count        = "${length(var.names)}"
  account_id   = "${local.prefix}${lower(element(var.names, count.index))}"
  display_name = "Terraform-managed service account"
  project      = "${var.project_id}"
}

# common roles
resource "google_project_iam_member" "project-roles" {
  count = "${length(var.project_roles) * length(var.names)}"

  project = "${element(
    split("=>", element(var.project_roles, count.index % length(var.project_roles))
  ), 0)}"

  role = "${element(
    split("=>", element(var.project_roles, count.index % length(var.project_roles))
  ), 1)}"

  member = "serviceAccount:${element(
    google_service_account.service_accounts.*.email,
    count.index / length(var.project_roles)
  )}"
}

# Bucket roles
resource "google_storage_bucket_iam_member" "bucket_roles" {
  count = "${length(var.bucket_roles) * length(var.names)}"

  bucket = "${element(
    split("=>", element(var.bucket_roles, count.index % length(var.bucket_roles))
  ), 0)}"

  role = "${element(
    split("=>", element(var.bucket_roles, count.index % length(var.bucket_roles))
  ), 1)}"

  member = "serviceAccount:${element(
    google_service_account.service_accounts.*.email,
    count.index / length(var.bucket_roles)
  )}"
}

resource "google_organization_iam_member" "org_roles" {
  count = "${length(local.org_roles) * length(var.names)}"

  org_id = "${element(
    split("=>", element(local.org_roles, count.index % length(local.org_roles))
  ), 0)}"

  role = "${element(
    split("=>", element(local.org_roles, count.index % length(local.org_roles))
  ), 1)}"

  member = "serviceAccount:${element(
    google_service_account.service_accounts.*.email,
    count.index / length(local.org_roles)
  )}"
}

resource "google_billing_account_iam_member" "billing_account_roles" {
  count = "${length(local.billing_account_roles) * length(var.names)}"

  billing_account_id = "${element(
    split("=>", element(local.billing_account_roles, count.index % length(local.billing_account_roles))
  ), 0)}"

  role = "${element(
    split("=>", element(local.billing_account_roles, count.index % length(local.billing_account_roles))
  ), 1)}"

  member = "serviceAccount:${element(
    google_service_account.service_accounts.*.email,
    count.index / length(local.billing_account_roles)
  )}"
}

# conditionally assign roles for shared VPC
# ref: https://cloud.google.com/vpc/docs/shared-vpc

# keys
resource "google_service_account_key" "keys" {
  count              = "${var.generate_keys ? length(var.names) : 0}"
  service_account_id = "${element(google_service_account.service_accounts.*.email, count.index)}"
}
