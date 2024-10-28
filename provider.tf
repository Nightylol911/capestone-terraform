# main.tf + variables.tf define your infrastructure and variables used in the Terraform script.
# Define the provider (Alibaba Cloud) and region to be used. 
# Initialize Terraform using the CLI command: terraform init
# Access key and secret key are fetched from variables (defined separately).
# The region is set to "me-central-1" (Middle East, Central region).
# https://www.alibabacloud.com/help/en/ecs/product-overview/regions-and-zones

provider "alicloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = "me-central-1"
}

# Define a variable to name the Terraform configuration
variable "name" {
  default = "terraform-alicloud"
}

# add the zones to the server
data "alicloud_zones" "default" {
  # First Line not needed
  available_disk_category     = "cloud_efficiency"
  available_resource_creation = "VSwitch"
}