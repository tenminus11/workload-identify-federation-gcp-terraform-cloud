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

provider "tfe" {
  token = var.tfe_token
}

variable "tfe_token" {
  description = "Terraform Cloud authentication token"
  type        = string
}
