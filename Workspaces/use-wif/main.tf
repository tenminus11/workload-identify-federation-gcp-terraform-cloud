locals {
  google_project_id = "hashitalks-wif-demo"
}

resource "google_storage_bucket" "example" {
  name     = "hashitalks-wif-demo-cloud-storage-bucket12345"
  location = "EU"
  project  = local.google_project_id
}
