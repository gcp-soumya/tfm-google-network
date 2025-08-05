# Configure the Google Cloud provider for the root module
provider "google" {
  project = var.gcp_project_id
  region  = "us-central1" # Default region for the provider, can be overridden by module inputs
}

# Call the custom 'vpc_network' module
module "gcp_vpcs_and_subnets" {
  source = "./modules/multiple_vpc_sub" # Path to your module directory

  project_id       = var.gcp_project_id
  vpc_networks     = var.network_configurations # Pass the complex variable to the module
}

# Output the self_links from the module for easy reference
output "created_vpcs" {
  description = "Self-links of the created VPC networks."
  value       = module.gcp_vpcs_and_subnets.vpc_network_self_links
}

output "created_subnets" {
  description = "Self-links of the created subnets."
  value       = module.gcp_vpcs_and_subnets.subnet_self_links
}

# Define the root variables that will be passed to the module
variable "gcp_project_id" {
  description = "Your GCP Project ID."
  type        = string
}

variable "network_configurations" {
  description = "Configurations for VPC networks and their subnets."
  type = map(object({
    name                    = string
    routing_mode            = string
    description             = string
    auto_create_subnetworks = bool

    subnets = list(object({
      name          = string
      ip_cidr_range = string
      region        = string
      description   = string
    }))
  }))
}
