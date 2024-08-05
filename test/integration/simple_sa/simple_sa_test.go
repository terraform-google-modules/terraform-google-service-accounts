// Copyright 2024 Google LLC
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

package simple

import (
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestSimpleSA(t *testing.T) {
	sa := tft.NewTFBlueprintTest(t)
	sa.DefineVerify(
		func(assert *assert.Assertions) {
			sa.DefaultVerify(assert)

			projectID := sa.GetTFSetupStringOutput("project_id")
			email := sa.GetStringOutput("email")
			bindings := gcloud.Runf(t, "projects get-iam-policy %s --flatten bindings --filter bindings.members:'serviceAccount:%s' --format json", projectID, email).Array()
			assert.Equal(2, len(bindings), "expect two bindings")

			expectedRoles := []string{"roles/compute.imageUser", "roles/compute.networkUser"}
			for _, b := range bindings {
				assert.Contains(expectedRoles, b.Get("bindings.role").String())
			}

			iam_email := sa.GetStringOutput("iam_email")
			env_vars := sa.GetStringOutput("env_vars")
			assert.Contains(iam_email, "serviceAccount:")
			assert.Contains(env_vars, "SERVICE_ACCOUNT_EMAIL")
			assert.Contains(env_vars, "SERVICE_ACCOUNT_IAM_EMAIL")
		})
	sa.Test()
}
