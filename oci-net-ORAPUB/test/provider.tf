
provider "oci" {
  tenancy_ocid = var.v_tenancy_ocid
  user_ocid = var.v_user_ocid
  private_key_path = var.v_private_key_path
  fingerprint = var.v_fingerprint
  region = var.v_region
}

