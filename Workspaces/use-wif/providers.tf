terraform {
  cloud {
    organization = "your-org"
    workspaces {
      name = "your-workspace"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.24.0"
    }
  }
}
