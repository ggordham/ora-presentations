
resource "oci_core_vcn" "coc_vcn" {
  
  compartment_id = var.v_comp_network_ocid

  # Optional parameters
  display_name = "cloud.oraontap.com"
  cidr_blocks = [ var.v_net_vcn_oraontap_cidr ]

  is_ipv6enabled = false

}

