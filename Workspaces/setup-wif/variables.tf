variable "google_project_id" {
  type        = string
  description = "The Google Cloud project ID used for deployment."
}

variable "organization_name" {
  type        = string
  description = "The HCP Terraform Organization to be used."
}

variable "workspace_ids" {
  type        = list(string)
  description = "List of HCP Terraform workspace IDs where the Workload Identity Federation configuration can be accessed. Navigate in the TFC Workspace GUI to general settings to find the ID 'ws-XXXXXXXXXXXXXXXX'."
}
