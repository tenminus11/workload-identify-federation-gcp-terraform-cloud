#-------------------------------------------------------------------------------
# Consumes Terraform Variable Set 
# Google Cloud Workload Identity (WIF) for HCP Terraform 
#-------------------------------------------------------------------------------

# Local variables 
locals {
  google_project_id  = "hashitalks-wif-demo"
  bucket_name_prefix = "hashitalks-use-wif-demo"
}

# Google Storage bucket name randomizer 
resource "random_id" "bucket_prefix" {
  byte_length = 8
}

# Create Google Storage bucket in EU region
resource "google_storage_bucket" "example" {
  name     = "${local.bucket_name_prefix}-${random_id.bucket_prefix.hex}"
  location = "EU"
  project  = local.google_project_id
}
