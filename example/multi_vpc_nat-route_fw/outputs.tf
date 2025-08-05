# outputs.tf

output "gcp_vpc_details" {
  description = "Details of the created GCP VPC networks, including IDs and subnet IDs."
  value = {
    for k, v in module.gcp_vpc : k => {
      network_id             = v.network_id
      network_self_link      = v.network_self_link
      public_subnet_ids      = v.public_subnet_ids
      public_subnet_links    = v.public_subnet_self_links
      private_subnet_ids     = v.private_subnet_ids
      private_subnet_links   = v.private_subnet_self_links
      cloud_router_ids       = v.cloud_router_ids
      cloud_nat_ids          = v.cloud_nat_ids
    }
  }
}
