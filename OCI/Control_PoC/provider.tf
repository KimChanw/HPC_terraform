provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# Get Oracle Linux 7.9 image
data "oci_core_images" "oracle_linux" {
  compartment_id          = var.compartment_ocid
  operating_system        = "Oracle Linux"
  operating_system_version = "7.9"
  shape                   = var.instance_shape

  filter {
    name   = "hkmc-os"
    values = ["Oracle-Linux-7.9-*"]
  }
}

# Get Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_ocid
}

# Create 10 instances
resource "oci_core_instance" "my_instance" {
  count            = 10
  compartment_id   = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  shape            = var.instance_shape
  display_name     = "hkmc-poc-${count.index + 1}"

  create_vnic_details {
    subnet_id          = var.subnet_id
    assign_public_ip   = false
    display_name       = "hkmc_poc_vnic_${count.index + 1}"
    hostname_label     = "hkmc-poc-${count.index + 1}"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oracle_linux.images[0].id
  }

  metadata = {
    ssh_authorized_keys = ""
  }
}