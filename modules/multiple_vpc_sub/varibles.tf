variable "project_id" {
  description = "The GCP project ID where the resources will be created."
  type        = string
}

variable "vpc_networks" {
  description = "A map of VPC network configurations. The map key is used as an internal identifier."
  type = map(object({
    name                    = string # The actual name of the VPC network in GCP
    routing_mode            = string # "REGIONAL" or "GLOBAL"
    description             = string
    auto_create_subnetworks = bool   # Must be false for custom subnets

    subnets = list(object({
      name          = string # The actual name of the subnet in GCP
      ip_cidr_range = string
      region        = string
      description   = string
    }))
  }))
}
