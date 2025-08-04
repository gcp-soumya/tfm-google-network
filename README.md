# Google Compute Network



# Module Inputs

# Name	Description	Type	Default	Required
project_id	The GCP project ID where the resources will be created.	string	n/a	yes
vpc_networks	A map of VPC network configurations. The map key is used as an internal identifier within Terraform.	map(object(...))	n/a	yes
The vpc_networks variable expects a map where each value is an object with the following attributes:

name (string): The name of the VPC network to create in GCP.
routing_mode (string): The routing mode for the VPC ("REGIONAL" or "GLOBAL").
description (string): A description for the VPC network.
auto_create_subnetworks (bool): Set to false to enable custom subnet creation.
subnets (list(object(...))): A list of subnet configurations for this VPC. Each subnet object has:
name (string): The name of the subnet.
ip_cidr_range (string): The IP CIDR range for the subnet (e.g., "10.10.0.0/20").
region (string): The GCP region where the subnet will be created.
description (string (string): A description for the subnet.


# Module Outputs
Name	Description
vpc_network_self_links	A map of self_links for the created VPC networks, keyed by their internal map identifier.
subnet_self_links	A map of self_links for the created subnets, keyed by 'vpc_identifier-subnet_name'.
# Requirements
Before using this module, ensure you have:

Terraform CLI: Version 1.0 or higher installed.
GCP Project: An active Google Cloud Project.
GCP Authentication: Authenticated your Terraform environment to GCP. The recommended way for local development is gcloud auth application-default login.
Compute Engine API: The Compute Engine API must be enabled in your GCP project.
# Providers
hashicorp/google (version >= 5.0)
# Contributing
Feel free to open issues or submit pull requests.
