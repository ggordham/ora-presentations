
# Internet gateway for DMZ network

resource "oci_core_internet_gateway" "oco_intg" {

  compartment_id = var.v_comp_network_ocid
  vcn_id = oci_core_vcn.coc_vcn.id

  display_name = "Internet gateway-cloud.oraontap.com"
  enabled = true

}


# NAT gateway for PROXY network

resource "oci_core_nat_gateway" "oco_natg" {

  compartment_id = var.v_comp_network_ocid
  vcn_id = oci_core_vcn.coc_vcn.id

  display_name = "NAT gateway-cloud.oraontap.com"
  block_traffic = false

}

# Service gateway for PROXY network

data "oci_core_services" "all_oci_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

resource "oci_core_service_gateway" "oco_srvg" {

  compartment_id = var.v_comp_network_ocid
  vcn_id = oci_core_vcn.coc_vcn.id

  display_name = "Service gateway-cloud.oraontap.com"
  services { 
    service_id = lookup(data.oci_core_services.all_oci_services.services[0], "id")
    # service_id = lookup(data.oci_core_services.all_oci_services[0], "id")

  }

}


