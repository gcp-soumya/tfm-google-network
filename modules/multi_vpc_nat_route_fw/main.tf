# modules/vpc_gcp/main.tf

# GCP VPC Network
resource "google_compute_network" "this" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false # We want to create custom subnets
  routing_mode            = var.routing_mode

  # labels = var.tags
  
}

# Public Subnets
resource "google_compute_subnetwork" "public" {
  for_each      = var.public_subnets
  project       = var.project_id
  name          = "${var.network_name}-${each.key}-public"
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.region
  network       = google_compute_network.this.self_link
  description   = each.value.description
  
  

#   # labels = merge(var.tags, {
#     "subnet_type" = "public"
#   })
}

# Private Subnets
resource "google_compute_subnetwork" "private" {
  for_each      = var.private_subnets
  project       = var.project_id
  name          = "${var.network_name}-${each.key}-private"
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.region
  network       = google_compute_network.this.self_link
  description   = each.value.description

  # labels = merge(var.tags, {
  #   "subnet_type" = "private"
  # })
}

# Cloud Router (required for Cloud NAT)
# Create one Cloud Router per region where private subnets exist and NAT is enabled
resource "google_compute_router" "nat_router" {
  for_each = {
    for region in distinct([for s in values(google_compute_subnetwork.private) : s.region]) : region => true
    if var.enable_nat_for_private_subnets
  }
  project = var.project_id
  name    = "${var.network_name}-${each.key}-router"
  region  = each.key
  network = google_compute_network.this.self_link

  # labels = var.tags
}

# Cloud NAT Gateway
# Configure Cloud NAT for each router created
resource "google_compute_router_nat" "private_nat" {
  for_each = {
    for region in distinct([for s in values(google_compute_subnetwork.private) : s.region]) : region => true
    if var.enable_nat_for_private_subnets
  }
  project                            = var.project_id
  name                               = "${var.network_name}-${each.key}-nat"
  router                             = google_compute_router.nat_router[each.key].name
  region                             = each.key
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY" # Can be ALL, TRANSLATIONS_ONLY, ERRORS_ONLY
  }

  depends_on = [
    google_compute_router.nat_router,
    google_compute_subnetwork.private
  ]
}

# Optional: Basic Firewall Rules for demonstration
# Allow internal traffic within the VPC
resource "google_compute_firewall" "internal_allow" {
  project     = var.project_id
  name        = "${var.network_name}-allow-internal"
  network     = google_compute_network.this.name
  description = "Allow internal traffic within the VPC."

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  source_ranges = distinct(concat(
  [for s in values(google_compute_subnetwork.public) : s.ip_cidr_range],
  [for s in values(google_compute_subnetwork.private) : s.ip_cidr_range]
))
  target_tags   = ["allow-internal"] # Apply to instances with this tag
}

# Allow SSH from anywhere (for public instances)
resource "google_compute_firewall" "allow_ssh_public" {
  project     = var.project_id
  name        = "${var.network_name}-allow-ssh-public"
  network     = google_compute_network.this.name
  description = "Allow SSH from anywhere to public instances."

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-ssh-public"] # Apply to instances with this tag
}

