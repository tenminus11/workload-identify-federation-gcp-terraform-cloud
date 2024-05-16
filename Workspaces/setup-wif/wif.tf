#-------------------------------------------------------------------------------
# Deploy Google Cloud Workload Identity (WIF) for HCP Terraform v1.0.0
#-------------------------------------------------------------------------------

# Local variables
locals {
  # Define the Google Cloud project ID used for deployment
  google_project_id = "hashitalks-wif-demo"

  # Define the HCP Terraform Organization to be used
  organization_name = "jliauw-demo-org"

  # List of HCP Terraform workspace IDs where the Workload Identity Federation configuration can be accessed
  # Navigate in the TFC Workspace GUI to general settings to find the ID "ws-XXXXXXXXXXXXXXXX".
  workspace_ids = [
    "ws-bs9m7sYDJ7PfLr1D",
  ]
}

# Create a Google Cloud Workload Identity (WIF) Pool for HCP Terraform
resource "google_iam_workload_identity_pool" "hcp_tf" {
  project                   = local.google_project_id
  workload_identity_pool_id = "hcp-tf-pool"
  display_name              = "HCP Terraform Pool"
  description               = "Used to authenticate to Google Cloud"
}

# Create a Google Cloud Workload Identity (WIF) Pool provider for HCP Terraform
resource "google_iam_workload_identity_pool_provider" "hcp_tf" {
  project                            = local.google_project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.hcp_tf.workload_identity_pool_id
  workload_identity_pool_provider_id = "hcp-tf-provider"
  display_name                       = "HCP Terraform Provider"
  description                        = "Used to authenticate to Google Cloud"
  attribute_condition                = "assertion.terraform_organization_name==\"${local.organization_name}\""
  attribute_mapping = {
    "google.subject"                     = "assertion.sub"
    "attribute.terraform_workspace_id"   = "assertion.terraform_workspace_id"
    "attribute.terraform_full_workspace" = "assertion.terraform_full_workspace"
  }
  oidc {
    #allowed_audiences = "https://iam.googleapis.com/projects/523177317825/locations/global/workloadIdentityPools/hcp-tf-pool/providers/hcp-tf-provider"
    issuer_uri = "https://app.terraform.io"
  }
}

# Example Google Cloud service account which HCP Terraform will impersonate
resource "google_service_account" "example" {
  project      = local.google_project_id
  account_id   = "example"
  display_name = "Service Account for HCP Terraform"
}

# IAM should verify the HCP Terraform Workspace ID before authorizing access to impersonate the 'example' Google Cloud service account
resource "google_service_account_iam_member" "example_workload_identity_user" {
  for_each           = toset(local.workspace_ids)
  service_account_id = google_service_account.example.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.hcp_tf.name}/attribute.terraform_workspace_id/${each.value}"
}

# Grant permissions, roles to the Google Cloud 'example' service account
resource "google_project_iam_member" "example_storage_admin" {
  project = local.google_project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.example.email}"
}

# Create a variable set to store the Workload Identity Federation (WIF) config for the 'example' service account
resource "tfe_variable_set" "example" {
  name         = google_service_account.example.account_id
  description  = "Workload Identity Federation configuration for ${google_service_account.example.name}"
  organization = local.organization_name
}

resource "tfe_variable" "example_provider_auth" {
  key             = "TFC_GCP_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  variable_set_id = tfe_variable_set.example.id
}

resource "tfe_variable" "example_service_account_email" {
  sensitive       = true
  key             = "TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL"
  value           = google_service_account.example.email
  category        = "env"
  variable_set_id = tfe_variable_set.example.id
}

resource "tfe_variable" "example_provider_name" {
  sensitive       = true
  key             = "TFC_GCP_WORKLOAD_PROVIDER_NAME"
  value           = google_iam_workload_identity_pool_provider.hcp_tf.name
  category        = "env"
  variable_set_id = tfe_variable_set.example.id
}

# Share the variable set with a HCP Terraform workspace, defined in the workspace_ids locals
resource "tfe_workspace_variable_set" "example" {
  for_each        = toset(local.workspace_ids)
  variable_set_id = tfe_variable_set.example.id
  workspace_id    = each.value
}
