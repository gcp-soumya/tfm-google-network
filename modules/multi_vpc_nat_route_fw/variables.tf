# modules/vpc_gcp/variables.tf

variable "project_id" {
  description = "The GCP project ID where resources will be created."
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network."
  type        = string
}

variable "routing_mode" {
  description = "The network routing mode (REGIONAL or GLOBAL)."
  type        = string
  default     = "REGIONAL"
  validation {
    condition     = contains(["REGIONAL", "GLOBAL"], upper(var.routing_mode))
    error_message = "routing_mode must be REGIONAL or GLOBAL."
  }
}

variable "public_subnets" {
  description = "A map of public subnet configurations."
  type = map(object({
    ip_cidr_range = string
    region        = string
    description   = optional(string, "Public subnet")
  }))
  default = {}
}

variable "private_subnets" {
  description = "A map of private subnet configurations."
  type = map(object({
    ip_cidr_range = string
    region        = string
    description   = optional(string, "Private subnet")
  }))
  default = {}
}

variable "enable_nat_for_private_subnets" {
  description = "Whether to enable Cloud NAT for private subnets in each region."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the network resource (GCP labels)."
  type        = map(string)
  default     = {}
}
