terraform {
  cloud {
    organization = "jliauw-demo-org"
    workspaces {
      name = "setup-wif"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.24.0"
    }
  }
}

# Create a env variable in your Terraform Cloud TFE_TOKEN
provider "tfe" {
  hostname = "app.terraform.io"
}
