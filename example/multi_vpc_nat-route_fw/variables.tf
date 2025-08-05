# variables.tf

variable "gcp_project_id" {
  description = "Your GCP Project ID."
  type        = string
}

variable "gcp_region" {
  description = "The default GCP region for resources if not specified per subnet."
  type        = string
  default     = "us-central1"
}

variable "project_prefix" {
  description = "A prefix for resource names."
  type        = string
  default     = "gcp-infra"
}

variable "gcp_vpcs" {
  description = "A map defining the configurations for multiple GCP VPC networks."
  type = map(object({
    routing_mode                   = optional(string, "REGIONAL")
    enable_nat_for_private_subnets = optional(bool, true)
    public_subnets = map(object({
      ip_cidr_range = string
      region        = optional(string) # Optional, will default to gcp_region if not provided
    }))
    private_subnets = map(object({
      ip_cidr_range = string
      region        = optional(string) # Optional, will default to gcp_region if not provided
    }))
  }))
  default = {
    "development" = {
      routing_mode                   = "REGIONAL"
      enable_nat_for_private_subnets = true
      public_subnets = {
        "web-us-central1" = {
          ip_cidr_range = "10.0.1.0/24"
          region        = "us-central1"
        },
        "web-us-east1" = {
          ip_cidr_range = "10.0.2.0/24"
          region        = "us-east1"
        }
      }
      private_subnets = {
        "app-us-central1" = {
          ip_cidr_range = "10.0.10.0/24"
          region        = "us-central1"
        },
        "db-us-central1" = {
          ip_cidr_range = "10.0.11.0/24"
          region        = "us-central1"
        },
        "app-us-east1" = {
          ip_cidr_range = "10.0.20.0/24"
          region        = "us-east1"
        }
      }
    },
    "production" = {
      routing_mode                   = "REGIONAL"
      enable_nat_for_private_subnets = true
      public_subnets = {
        "web-us-central1" = {
          ip_cidr_range = "10.1.1.0/24"
          region        = "us-central1"
        },
        "web-us-west1" = {
          ip_cidr_range = "10.1.2.0/24"
          region        = "us-west1"
        }
      }
      private_subnets = {
        "app-us-central1" = {
          ip_cidr_range = "10.1.10.0/24"
          region        = "us-central1"
        },
        "db-us-central1" = {
          ip_cidr_range = "10.1.11.0/24"
          region        = "us-central1"
        },
        "app-us-west1" = {
          ip_cidr_range = "10.1.20.0/24"
          region        = "us-west1"
        }
      }
    }
  }
}


