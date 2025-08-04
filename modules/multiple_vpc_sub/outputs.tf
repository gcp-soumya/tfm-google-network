output "vpc_network_self_links" {
  description = "A map of self_links for the created VPC networks, keyed by their internal map identifier."
  value       = { for k, v in google_compute_network.main : k => v.self_link }
}

output "subnet_self_links" {
  description = "A map of self_links for the created subnets, keyed by 'vpc_identifier-subnet_name'."
  value       = { for k, v in google_compute_subnetwork.main : k => v.self_link }
}
