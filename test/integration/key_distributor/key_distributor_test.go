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

package key_distributor_test

import (
	"os/exec"
	"strings"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestKeyDistributor(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t)
	bpt.DefineVerify(
		func(assert *assert.Assertions) {
			bpt.DefaultVerify(assert)

			email := bpt.GetStringOutput("email")

			cmd := exec.Command("./../../fixtures/key_distributor/get-key", email)
			var stdout strings.Builder
			var stderr strings.Builder
			cmd.Stdout = &stdout
			cmd.Stderr = &stderr

			assert.Nil(cmd.Run())

			assert.Equal("", stderr.String())
			assert.Regexp("^Success! Wrote encrypted key", stdout.String())
		})
	bpt.Test()
}
