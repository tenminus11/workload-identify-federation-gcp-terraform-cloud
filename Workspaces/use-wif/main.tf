#-------------------------------------------------------------------------------
# Consumes Terraform Variable Set 
# Google Cloud Workload Identity (WIF) for HCP Terraform 
#-------------------------------------------------------------------------------

variable "google_project_id" {
  type        = string
  description = "The Google Cloud project ID used for deployment."
}

variable "bucket_name_prefix" {
  type        = string
  description = "The Google Cloud gcs name prefix"
}


# Google Storage bucket name randomizer 
resource "random_id" "bucket_prefix" {
  byte_length = 8
}

# Create Google Storage bucket in EU region
resource "google_storage_bucket" "example" {
  name     = "${var.bucket_name_prefix}-${random_id.bucket_prefix.hex}"
  location = "EU"
  project  = var.google_project_id
}
