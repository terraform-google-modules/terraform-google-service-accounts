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
  type        = string
  description = "Project id where service account will be created."
}

variable "prefix" {
  type        = string
  description = "Prefix applied to service account names."
  default     = ""
}

variable "names" {
  type        = list(string)
  description = "Names of the service accounts to create."
  default     = []
}

variable "project_roles" {
  type        = list(string)
  description = "Common roles to apply to all service accounts, project=>role as elements."
  default     = []
}

variable "grant_billing_role" {
  type        = bool
  description = "Grant billing user role."
  default     = false
}

variable "billing_account_id" {
  type        = string
  description = "If assigning billing role, specificy a billing account (default is to assign at the organizational level)."
  default     = ""
}

variable "grant_xpn_roles" {
  type        = bool
  description = "Grant roles for shared VPC management."
  default     = true
}

variable "org_id" {
  type        = string
  description = "Id of the organization for org-level roles."
  default     = ""
}

variable "generate_keys" {
  type        = bool
  description = "Generate keys for service accounts."
  default     = false
}

variable "display_name" {
  type        = string
  description = "Display names of the created service accounts (defaults to 'Terraform-managed service account')"
  default     = "Terraform-managed service account"
}

variable "description" {
  type        = string
  description = "Default description of the created service accounts (defaults to no description)"
  default     = ""
}

variable "descriptions" {
  type        = list(string)
  description = "List of descriptions for the created service accounts (elements default to the value of `description`)"
  default     = []
}
