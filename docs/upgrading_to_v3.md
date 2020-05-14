# Upgrading to v3.0

The v3.0 release is a backwards-incompatible release.

### for_each
The resources in this module have been updated to use `for_each` instead of `count`. This allows adding/removing service accounts without causing a diff on unrelated resources.

Updating to this new format requires running a state migration. Note that this migration **must** be run with **Terraform v0.12.20**. You can use a [script](../helpers/migrate.py) we provided to automatically make the required state migration.

1. Download the script

    ```sh
    curl -O https://raw.githubusercontent.com/terraform-google-modules/terraform-google-service-accounts/master/helpers/migrate.py
    chmod +x migrate.py
    ```

2. Run the script in dryrun mode to confirm the expected changes:

    ```sh
    $ ./migrate.py --dryrun

    ---- Migrating the following modules:
    -- module.service_accounts
    ---- Commands to run:
    terraform state mv 'module.service_accounts.google_service_account.service_accounts[0]' 'module.service_accounts.google_service_account.service_accounts["test-first"]'
    terraform state mv 'module.service_accounts.google_service_account.service_accounts[1]' 'module.service_accounts.google_service_account.service_accounts["test-second"]'
    terraform state mv 'module.service_accounts.google_service_account_key.keys[0]' 'module.service_accounts.google_service_account_key.keys["test-first"]'
    terraform state mv 'module.service_accounts.google_service_account_key.keys[1]' 'module.service_accounts.google_service_account_key.keys["test-second"]'
    ```

3. Execute the migration script

    ```sh
    $ ./migrate.py

    ---- Migrating the following modules:
    -- module.service_accounts
    ---- Commands to run:
    Move "module.service_accounts.google_service_account.service_accounts[0]" to "module.service_accounts.google_service_account.service_accounts[\"test-first\"]"
    Successfully moved 1 object(s).
    Move "module.service_accounts.google_service_account.service_accounts[1]" to "module.service_accounts.google_service_account.service_accounts[\"test-second\"]"
    Successfully moved 1 object(s).
    Move "module.service_accounts.google_service_account_key.keys[0]" to "module.service_accounts.google_service_account_key.keys[\"test-first\"]"
    Successfully moved 1 object(s).
    Move "module.service_accounts.google_service_account_key.keys[1]" to "module.service_accounts.google_service_account_key.keys[\"test-second\"]"
    Successfully moved 1 object(s).
    ```

4. Run `terraform plan` to confirm only 4 IAM changes will be made.

    ```
    Terraform will perform the following actions:

    # module.service_accounts.google_project_iam_member.project-roles will be destroyed
    - resource "google_project_iam_member" "project-roles" {
        - etag    = "BwWlo2qcwSc=" -> null
        - id      = "PROJECT_ID/roles/viewer/serviceAccount:test-first@PROJECT_ID.iam.gserviceaccount.com" -> null
        - member  = "serviceAccount:test-first@PROJECT_ID.iam.gserviceaccount.com" -> null
        - project = "PROJECT_ID" -> null
        - role    = "roles/viewer" -> null
      }

    # module.service_accounts.google_project_iam_member.project-roles[1] will be destroyed
    - resource "google_project_iam_member" "project-roles" {
        - etag    = "BwWlo2qcwSc=" -> null
        - id      = "PROJECT_ID/roles/storage.objectViewer/serviceAccount:test-first@PROJECT_ID.iam.gserviceaccount.com" -> null
        - member  = "serviceAccount:test-first@PROJECT_ID.iam.gserviceaccount.com" -> null
        - project = "PROJECT_ID" -> null
        - role    = "roles/storage.objectViewer" -> null
      }

    # module.service_accounts.google_project_iam_member.project-roles[2] will be destroyed
    - resource "google_project_iam_member" "project-roles" {
        - etag    = "BwWlo2qcwSc=" -> null
        - id      = "PROJECT_ID/roles/viewer/serviceAccount:test-second@PROJECT_ID.iam.gserviceaccount.com" -> null
        - member  = "serviceAccount:test-second@PROJECT_ID.iam.gserviceaccount.com" -> null
        - project = "PROJECT_ID" -> null
        - role    = "roles/viewer" -> null
      }

    # module.service_accounts.google_project_iam_member.project-roles[3] will be destroyed
    - resource "google_project_iam_member" "project-roles" {
        - etag    = "BwWlo2qcwSc=" -> null
        - id      = "PROJECT_ID/roles/storage.objectViewer/serviceAccount:test-second@PROJECT_ID.iam.gserviceaccount.com" -> null
        - member  = "serviceAccount:test-second@PROJECT_ID.iam.gserviceaccount.com" -> null
        - project = "PROJECT_ID" -> null
        - role    = "roles/storage.objectViewer" -> null
      }

    # module.service_accounts.google_project_iam_member.project-roles["test-first-PROJECT_ID=>roles/storage.objectViewer"] will be created
    + resource "google_project_iam_member" "project-roles" {
        + etag    = (known after apply)
        + id      = (known after apply)
        + member  = "serviceAccount:test-first@PROJECT_ID.iam.gserviceaccount.com"
        + project = "PROJECT_ID"
        + role    = "roles/storage.objectViewer"
      }

    # module.service_accounts.google_project_iam_member.project-roles["test-first-PROJECT_ID=>roles/viewer"] will be created
    + resource "google_project_iam_member" "project-roles" {
        + etag    = (known after apply)
        + id      = (known after apply)
        + member  = "serviceAccount:test-first@PROJECT_ID.iam.gserviceaccount.com"
        + project = "PROJECT_ID"
        + role    = "roles/viewer"
      }

    # module.service_accounts.google_project_iam_member.project-roles["test-second-PROJECT_ID=>roles/storage.objectViewer"] will be created
    + resource "google_project_iam_member" "project-roles" {
        + etag    = (known after apply)
        + id      = (known after apply)
        + member  = "serviceAccount:test-second@PROJECT_ID.iam.gserviceaccount.com"
        + project = "PROJECT_ID"
        + role    = "roles/storage.objectViewer"
      }

    # module.service_accounts.google_project_iam_member.project-roles["test-second-PROJECT_ID=>roles/viewer"] will be created
    + resource "google_project_iam_member" "project-roles" {
        + etag    = (known after apply)
        + id      = (known after apply)
        + member  = "serviceAccount:test-second@PROJECT_ID.iam.gserviceaccount.com"
        + project = "PROJECT_ID"
        + role    = "roles/viewer"
      }

    Plan: 4 to add, 0 to change, 4 to destroy.
    ```

5. Run `terraform apply` to finalize the migration.

  ```
  Apply complete! Resources: 4 added, 0 changed, 4 destroyed.
  ```
