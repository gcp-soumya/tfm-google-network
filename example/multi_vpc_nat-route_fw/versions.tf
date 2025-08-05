# versions.tf

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0" # Use a compatible version
    }
  }
  required_version = ">= 1.0"
}
