# modules/vpc_gcp/outputs.tf

output "network_id" {
  description = "The ID of the GCP VPC network."
  value       = google_compute_network.this.id
}

output "network_self_link" {
  description = "The self_link of the GCP VPC network."
  value       = google_compute_network.this.self_link
}

output "public_subnet_ids" {
  description = "A map of public subnet IDs keyed by their names."
  value       = { for k, v in google_compute_subnetwork.public : k => v.id }
}

output "public_subnet_self_links" {
  description = "A map of public subnet self_links keyed by their names."
  value       = { for k, v in google_compute_subnetwork.public : k => v.self_link }
}

output "private_subnet_ids" {
  description = "A map of private subnet IDs keyed by their names."
  value       = { for k, v in google_compute_subnetwork.private : k => v.id }
}

output "private_subnet_self_links" {
  description = "A map of private subnet self_links keyed by their names."
  value       = { for k, v in google_compute_subnetwork.private : k => v.self_link }
}

output "cloud_router_ids" {
  description = "A map of Cloud Router IDs keyed by region (if created)."
  value       = var.enable_nat_for_private_subnets ? { for k, v in google_compute_router.nat_router : k => v.id } : {}
}

output "cloud_nat_ids" {
  description = "A map of Cloud NAT IDs keyed by region (if created)."
  value       = var.enable_nat_for_private_subnets ? { for k, v in google_compute_router_nat.private_nat : k => v.id } : {}
}
