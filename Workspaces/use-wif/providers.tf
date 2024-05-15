terraform {
  cloud {
    organization = "jliauw-demo-org"
    workspaces {
      name = "use-wif"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.24.0"
    }
  }
}
