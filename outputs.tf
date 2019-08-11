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

output "email" {
  description = "Service account email (single-use case)."
  value       = google_service_account.service_accounts[0].email
}

output "iam_email" {
  description = "IAM-format service account email (single-use case)."
  value       = "serviceAccount:${google_service_account.service_accounts[0].email}"
}

output "emails" {
  description = "List of service account emails."
  value       = google_service_account.service_accounts.*.email
}

output "iam_emails" {
  description = "List of IAM-format service account emails."
  value = formatlist(
    "serviceAccount:%s",
    google_service_account.service_accounts.*.email,
  )
}

data "template_file" "keys" {
  count    = length(var.names)
  template = "$${key}"

  vars = {
    key = var.generate_keys ? base64decode(
      element(
        concat(google_service_account_key.keys.*.private_key, [""]),
        count.index,
      ),
    ) : ""
  }
}

output "keys" {
  description = "Map of service account keys."
  sensitive   = true
  value = zipmap(
    formatlist("%s-key.json", var.names),
    data.template_file.keys.*.rendered,
  )
}

