#!/bin/bash
EMAIL=$1
if [ -z "$EMAIL" ]; then
  echo -e "ERROR: (get-key) Must supply a service account email to generate a key."
  echo "Usage: get-key SERVICE_ACCOUNT_EMAIL"
  exit 1
fi
OUTPUT=$EMAIL.json.gpg
gcloud functions call ${function} \
  --data "{\"email\": \"$EMAIL\"}" \
  --region ${region} \
  --project ${project} \
  --format="value(result)" | jq -r .encryptedKey | base64 --decode > $OUTPUT
echo "Success! Wrote encrypted key to $OUTPUT"
