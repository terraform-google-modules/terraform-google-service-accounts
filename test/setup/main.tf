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
  per_module_services = {
    key-distributor = [
      "iam.googleapis.com",
      "secretmanager.googleapis.com",
      "serviceusage.googleapis.com",
    ]
    simple-sa = [
      "iam.googleapis.com",
      "serviceusage.googleapis.com",
      "cloudresourcemanager.googleapis.com",
    ]
    root = [
      "iam.googleapis.com",
      "secretmanager.googleapis.com",
      "serviceusage.googleapis.com",
      "cloudresourcemanager.googleapis.com",
    ]
  }
}

module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 18.0"

  name              = "ci-service-accounts"
  random_project_id = "true"
  org_id            = var.org_id
  folder_id         = var.folder_id
  billing_account   = var.billing_account

  activate_apis = concat([
    "secretmanager.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudbuild.googleapis.com",
  ], flatten(values(local.per_module_services)))
}
