/*
Copyright 2020 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package encrypter

import (
	"bytes"
	"context"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"golang.org/x/crypto/openpgp"
	"golang.org/x/crypto/openpgp/armor"
	"golang.org/x/crypto/openpgp/packet"
	iam "google.golang.org/api/iam/v1"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"regexp"
	"strings"
)

type encryptRequest struct {
	Email string `json:"email"`
}

type encryptResponse struct {
	EncryptedKey string `json:"encryptedKey"`
}

// Initialize this so the background context persists between invocations.
var iamService *iam.Service

func init() {
	ctx := context.Background()
	var err error
	if iamService, err = iam.NewService(ctx); err != nil {
		log.Fatal(err)
	}
}

func GenerateAndEncrypt(w http.ResponseWriter, r *http.Request) {
	// Read request bytes
	data, err := ioutil.ReadAll(r.Body)
	if err != nil {
		e := fmt.Sprintf("Error reading request: %v", err)
		http.Error(w, e, http.StatusBadRequest)
		return
	}

	// Parse the request body to get the Service Account email
	input := encryptRequest{}
	if err := json.Unmarshal(data, &input); err != nil {
		e := fmt.Sprintf("Error parsing request: %v", err)
		http.Error(w, e, http.StatusBadRequest)
		return
	}

	// Read in public key
	recipient, err := readEntity(os.Getenv("PUBLIC_KEY"))
	if err != nil {
		e := fmt.Sprintf("Could not parse public key: %v", err)
		http.Error(w, e, http.StatusInternalServerError)
		return
	}

	// Create service account key
	b64key, err := createServiceAccountKey(input.Email)
	if err != nil {
		e := fmt.Sprintf("Could not create Service Account key: %v", err)
		http.Error(w, e, http.StatusInternalServerError)
		return
	}
	key, err := base64.URLEncoding.DecodeString(b64key)
	if err != nil {
		e := fmt.Sprintf("Could not decode service account key: %v", err)
		http.Error(w, e, http.StatusInternalServerError)
		return
	}

	// Do the encryption
	var encryptedData bytes.Buffer
	if err = encrypt(recipient, nil, string(key), &encryptedData); err != nil {
		e := fmt.Sprintf("Could not encrypt: %v", err)
		http.Error(w, e, http.StatusInternalServerError)
		return
	}

	// Create the response object
	resp, err := json.Marshal(encryptResponse{
		EncryptedKey: base64.StdEncoding.EncodeToString(encryptedData.Bytes()),
	})
	if err != nil {
		e := fmt.Sprintf("Could not marshal response: %v", err)
		http.Error(w, e, http.StatusInternalServerError)
		return
	}

	// Write the response
	io.WriteString(w, string(resp))
}

func encrypt(recipient, signer *openpgp.Entity, plaintext string, w io.Writer) error {
	r := strings.NewReader(plaintext)
	wc, err := openpgp.Encrypt(w, []*openpgp.Entity{recipient}, signer, &openpgp.FileHints{IsBinary: true}, nil)
	if err != nil {
		return err
	}
	if _, err := io.Copy(wc, r); err != nil {
		return err
	}
	return wc.Close()
}

func readEntity(pubKey string) (*openpgp.Entity, error) {
	f := strings.NewReader(pubKey)
	block, err := armor.Decode(f)
	if err != nil {
		return nil, err
	}
	return openpgp.ReadEntity(packet.NewReader(block.Body))
}

func parseEmail(email string) (string, error) {
	re := regexp.MustCompile(`@(.*?)\.`)
	matches := re.FindStringSubmatch(email)
	if len(matches) != 2 {
		return "", fmt.Errorf("Could not parse service account email")
	}
	project := matches[1]
	return fmt.Sprintf("projects/%s/serviceAccounts/%s", project, email), nil
}

func createServiceAccountKey(email string) (string, error) {
	saName, err := parseEmail(email)
	if err != nil {
		return "", err
	}
	saService := iam.NewProjectsServiceAccountsKeysService(iamService)
	key, err := saService.Create(saName, &iam.CreateServiceAccountKeyRequest{
		KeyAlgorithm:   "KEY_ALG_RSA_2048",
		PrivateKeyType: "TYPE_GOOGLE_CREDENTIALS_FILE",
	}).Do()
	if err != nil {
		return "nil", err
	}
	return key.PrivateKeyData, nil
}
