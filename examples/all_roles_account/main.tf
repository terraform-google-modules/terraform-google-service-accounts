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

provider "google" {
  version = "~> 2.7.0"
}


resource "google_storage_bucket" "test_bucket" {
  project = "${var.project_id}"
  name    = "${var.bucket_name}"
}

module "all_roles" {
  source                = "../.."
  project_id            = "${var.project_id}"
  org_id                = "${var.org_id}"
  prefix                = "${var.prefix}"
  names                 = ["all-roles-account"]
  project_roles         = ["${var.project_id}=>roles/viewer"]
  org_roles             = ["${var.org_id}=>roles/compute.admin"]
  bucket_roles          = ["${var.bucket_name}=>roles/storage.objectViewer"]
  billing_account_roles = ["${var.billing_account_id}=>roles/billing.admin"]
}
