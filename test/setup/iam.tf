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

  per_module_roles = {
    key-distributor = [
      "roles/iam.serviceAccountKeyAdmin",
      "roles/iam.serviceAccountUser",
      "roles/secretmanager.secretAdmin",
      "roles/logging.logWriter",
    ]
    simple-sa = [
      "roles/iam.serviceAccountAdmin",
      "roles/iam.serviceAccountUser",
      "roles/logging.logWriter",
    ]
    root = [
      "roles/resourcemanager.projectIamAdmin",
      "roles/serviceusage.serviceUsageAdmin",
      "roles/iam.serviceAccountAdmin",
      "roles/iam.serviceAccountUser",
    ]
  }

  int_required_roles = concat([
    "roles/storage.admin",
    "roles/cloudfunctions.admin",
  ], flatten(values(local.per_module_roles)))
}

resource "google_service_account" "int_test" {
  project      = module.project.project_id
  account_id   = "ci-account"
  display_name = "ci-account"
}

resource "google_project_iam_member" "int_test" {
  for_each = toset(local.int_required_roles)

  project = module.project.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_service_account_key" "int_test" {
  service_account_id = google_service_account.int_test.id
}
