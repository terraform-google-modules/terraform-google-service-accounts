/**
 * Copyright 2020 Google LLC
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
  function_files = [
    "${path.module}/files/function/main.go",
    "${path.module}/files/function/go.mod",
  ]
  function_md5sums     = [for f in local.function_files : filemd5(f)]
  function_dirchecksum = md5(join("-", local.function_md5sums))
  project_ids          = toset(concat([var.project_id], var.project_ids))
}

resource "google_storage_bucket" "function_bucket" {
  project       = var.project_id
  name          = "${var.project_id}-function-${var.function_name}"
  location      = "US"
  force_destroy = true
}

data "archive_file" "function" {
  type        = "zip"
  source_dir  = "${path.module}/files/function"
  output_path = "${path.module}/files/build/${local.function_dirchecksum}.zip"
}

resource "google_storage_bucket_object" "archive" {
  name   = data.archive_file.function.output_path
  bucket = google_storage_bucket.function_bucket.name
  source = data.archive_file.function.output_path
}

resource "google_service_account" "distributor" {
  project      = var.project_id
  account_id   = "key-distributor"
  display_name = "Cloud Function to generate and encrypt SA keys"
}

# NOTE: The Cloud Function will programmatically create keys
# and encrypt them. This may need to happen across projects
resource "google_organization_iam_member" "distributor" {
  count  = var.org_id != "" ? 1 : 0
  member = "serviceAccount:${google_service_account.distributor.email}"
  role   = "roles/iam.serviceAccountKeyAdmin"
  org_id = var.org_id
}

resource "google_folder_iam_member" "distributor" {
  for_each = toset(var.folder_ids)
  member   = "serviceAccount:${google_service_account.distributor.email}"
  role     = "roles/iam.serviceAccountKeyAdmin"
  folder   = each.value
}

resource "google_project_iam_member" "distributor" {
  for_each = local.project_ids
  member   = "serviceAccount:${google_service_account.distributor.email}"
  role     = "roles/iam.serviceAccountKeyAdmin"
  project  = var.project_id
}

resource "google_cloudfunctions_function" "function" {
  project      = var.project_id
  region       = var.region
  name         = var.function_name
  description  = "Generates and encrypts a new Service Account key given a GPG public key"
  runtime      = "go113"
  trigger_http = true

  service_account_email = google_service_account.distributor.email
  source_archive_bucket = google_storage_bucket.function_bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  entry_point           = "GenerateAndEncrypt"
  environment_variables = {
    PUBLIC_KEY = file(var.public_key_file)
  }
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  for_each       = toset(var.function_members)
  project        = var.project_id
  cloud_function = google_cloudfunctions_function.function.name
  region         = var.region
  role           = "roles/cloudfunctions.invoker"
  member         = each.value
}

resource "local_file" "invoker" {
  filename        = "get-key"
  file_permission = "0755"
  content = templatefile("${path.module}/templates/get-key.tpl", {
    project  = var.project_id
    region   = var.region
    function = var.function_name
  })
}
