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

variable "project_id" {
  description = "Project id where service account will be created."
}

variable "prefix" {
  description = "Prefix applied to service account names."
  default     = ""
}

variable "names" {
  description = "Names of the service accounts to create."
  default     = []
}

variable "project_roles" {
  description = "Common roles to bind to all service accounts for the specified project, project_id=>role as elements."
  default     = []
}

variable "org_roles" {
  description = "Common organization roles to bind to all service accounts."
  default     = []
}

variable "bucket_roles" {
  description = "Common roles to bind to all service accounts for the specified GCS bucket, bucket_id=>role as elements."
  default     = []
}

variable "billing_account_roles" {
  description = "Common roles to bind to all service accounts for the specified billing accounts, billing_account_id=>role as elements."
  default     = []
}

variable "grant_billing_role" {
  description = "Grant the billing user role"
  default     = false
}

variable "billing_account_id" {
  description = "If assigning billing role, specify a billing account (default is to assign at the organizational level)."
  default     = ""
}

variable "grant_xpn_roles" {
  description = "Grant roles for shared VPC management."
  default     = true
}

variable "org_id" {
  description = "Id of the organization for org-level roles."
  default     = ""
}

variable "generate_keys" {
  description = "Generate keys for service accounts."
  default     = false
}
