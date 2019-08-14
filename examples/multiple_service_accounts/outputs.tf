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

output "emails" {
  description = "The service account emails."
  value       = module.service_accounts.emails
}

output "emails_list" {
  description = "The service account emails as a list."
  value       = module.service_accounts.emails_list
}

output "iam_emails" {
  description = "The service account IAM-format emails as a map."
  value       = module.service_accounts.iam_emails
}

output "keys" {
  description = "The service account keys."
  value       = module.service_accounts.keys
}

