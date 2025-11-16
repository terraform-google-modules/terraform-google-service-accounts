// Copyright 2025 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package multiple_service_accounts

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
	"github.com/tidwall/gjson"
)

// membersOfRole queries the given project using gcloud for the members
// of the given role. The result is returned as a plain []string.
func membersOfRole(t *testing.T, projectID string, role string) ([]string, error) {
	cmd := fmt.Sprintf("projects get-iam-policy %s --flatten=bindings --filter=bindings.role:'%s' --format=json", projectID, role)
	output, err := gcloud.RunCmdE(t, cmd)
	if err != nil {
		return nil, fmt.Errorf("Failed running %q: %v, output=%q", cmd, err, output)
	}

	bindings := gjson.Parse(output).Array()
	if len(bindings) != 1 {
		return nil, fmt.Errorf("filtering for one role should produce one binding, instead got %v", output)
	}

	var members []string
	for _, member := range bindings[0].Get("bindings.members").Array() {
		members = append(members, member.String())
	}
	return members, nil
}

func TestMultipleServiceAccounts(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t)
	bpt.DefineVerify(
		func(assert *assert.Assertions) {
			bpt.DefaultVerify(assert)

			project_id := bpt.GetTFSetupStringOutput("project_id")

			viewers, err := membersOfRole(t, project_id, "roles/viewer")
			assert.Nil(err)
			objectViewers, err := membersOfRole(t, project_id, "roles/storage.objectViewer")
			assert.Nil(err)

			iam_emails := bpt.GetJsonOutput("iam_emails").Map()
			assert.Len(iam_emails, 2, "expected 2 entries in output iam_emails")

			for _, email := range iam_emails {
				assert.Contains(viewers, email.String(), "expected to find %q in queried viewers list", email.String())
				assert.Contains(objectViewers, email.String(), "expected to find %q in queried storage.objectViewers list", email.String())
			}

			foundEmailsJSON := gcloud.Runf(t, "iam service-accounts list --project=%s --flatten=email", project_id).Array()
			var foundEmails []string
			for _, found := range foundEmailsJSON {
				foundEmails = append(foundEmails, found.String())
			}

			emails_list := bpt.GetJsonOutput("emails_list").Array()
			assert.Len(emails_list, 2, "expected 2 entries in output emails_list")
			for _, email := range emails_list {
				assert.Contains(foundEmails, email.String(), "expected to find %q in queried emails list", email.String())
			}
		})
	bpt.Test()
}
