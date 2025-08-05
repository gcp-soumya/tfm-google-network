
# Create multiple GCP VPC networks using the module
module "gcp_vpc" {
  for_each = var.gcp_vpcs

  source = "./modules/multi_vpc_nat_route_fw"

  project_id                     = var.gcp_project_id
  network_name                   = "${var.project_prefix}-${each.key}-network"
  routing_mode                   = each.value.routing_mode
  enable_nat_for_private_subnets = each.value.enable_nat_for_private_subnets

  public_subnets = {
    for k, v in each.value.public_subnets : k => {
      ip_cidr_range = v.ip_cidr_range
      region        = coalesce(v.region, var.gcp_region) # Use subnet region or default
      description   = "Public subnet for ${each.key} in ${coalesce(v.region, var.gcp_region)}"
    }
  }

  private_subnets = {
    for k, v in each.value.private_subnets : k => {
      ip_cidr_range = v.ip_cidr_range
      region        = coalesce(v.region, var.gcp_region) # Use subnet region or default
      description   = "Private subnet for ${each.key} in ${coalesce(v.region, var.gcp_region)}"
    }
  }

  tags = {
    environment = each.key
    project     = var.project_prefix
    managed_by  = "terraform"
  }
}
