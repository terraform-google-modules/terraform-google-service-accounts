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


resource "google_cloudfunctions2_function" "function" {
  project     = var.project_id
  location    = var.region
  name        = var.function_name
  description = "Generates and encrypts a new Service Account key given a GPG public key"

  build_config {
    runtime     = "go126"
    entry_point = "GenerateAndEncrypt"
    source {
      storage_source {
        bucket = google_storage_bucket.function_bucket.name
        object = google_storage_bucket_object.archive.name
      }
    }
  }

  service_config {
    service_account_email = google_service_account.distributor.email
    environment_variables = {
      PUBLIC_KEY = file(var.public_key_file)
    }
  }
}

resource "google_cloudfunctions2_function_iam_member" "invoker" {
  for_each       = toset(var.function_members)
  project        = var.project_id
  location       = var.region
  cloud_function = google_cloudfunctions2_function.function.name
  role           = "roles/cloudfunctions.invoker"
  member         = each.value
}

resource "local_file" "invoker" {
  depends_on      = [time_sleep.wait_for_iam]
  filename        = "get-key"
  file_permission = "0755"
  content = templatefile("${path.module}/templates/get-key.tpl", {
    project  = var.project_id
    region   = var.region
    function = var.function_name
  })
}

resource "time_sleep" "wait_for_iam" {
  create_duration = "60s"
  depends_on = [
    google_organization_iam_member.distributor,
    google_folder_iam_member.distributor,
    google_project_iam_member.distributor,
    google_cloudfunctions2_function_iam_member.invoker
  ]
}
