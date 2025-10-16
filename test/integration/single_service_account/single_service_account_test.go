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

package single_service_account

import (
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestSingleServiceAccount(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t)
	bpt.DefineVerify(
		func(assert *assert.Assertions) {
			bpt.DefaultVerify(assert)

			project_id := bpt.GetTFSetupStringOutput("project_id")
			email := bpt.GetStringOutput("email")
			iam_email := bpt.GetStringOutput("iam_email")

			assert.Equal(project_id, gcloud.Runf(t, "iam service-accounts describe %s --format=json", email).Get("projectId").String(), "fetched project ID should match")

			role := "roles/viewer"
			bindings := gcloud.Runf(t, "projects get-iam-policy %s --flatten=bindings --filter=bindings.role:'%s' --format=json", project_id, role).Array()
			assert.Len(bindings, 1, "filtering for one role should produce one binding, instead got %v", bindings)

			var viewers []string
			for _, member := range bindings[0].Get("bindings.members").Array() {
				viewers = append(viewers, member.String())
			}
			assert.Contains(viewers, iam_email, "expected to find %q in queried viewers list", iam_email)
		})
	bpt.Test()
}
