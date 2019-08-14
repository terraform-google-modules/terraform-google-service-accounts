# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

control "gcp" do
  title "GCP Resources"

  attribute('iam_emails').each_value do |email|
    describe google_project_iam_binding(project: "#{attribute("project_id")}",  role: 'roles/viewer') do
      its('members') {should include email }
    end
    describe google_project_iam_binding(project: "#{attribute("project_id")}",  role: 'roles/storage.objectViewer') do
      its('members') {should include email }
    end
  end

  attribute('emails_list').each do |email|
    describe google_service_accounts(project: "#{attribute('project_id')}") do
      its('service_account_emails'){ should include email }
    end
  end

end
