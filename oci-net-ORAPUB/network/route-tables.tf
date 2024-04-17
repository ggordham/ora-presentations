

resource "oci_core_route_table" "oco_rt_internal" {

  compartment_id = var.v_comp_network_ocid
  vcn_id = oci_core_vcn.coc_vcn.id
  display_name = "RT INTERNAL subnet-cloud.oraontap.com"

  route_rules {
    # Note the oci services data is stored in gateways.tf file by the services gateway
    destination       = lookup(data.oci_core_services.all_oci_services.services[0], "cidr_block")
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.oco_srvg.id
    description = "Internal networks route to Service gateway for OCI services"
  }

  route_rules {
    destination = var.v_net_onprem_cidr
    network_entity_id = var.v_drg_ocid
    description = "Access to on-premise network."
  }
}


resource "oci_core_route_table" "oco_rt_proxy" {

  compartment_id = var.v_comp_network_ocid
  vcn_id = oci_core_vcn.coc_vcn.id
  display_name = "RT PROXY subnet-cloud.oraontap.com"

  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.oco_natg.id
    description = "PROXY networks route to NAT gateway for Internet"
  }

  route_rules {
    destination = var.v_net_onprem_cidr
    network_entity_id = var.v_drg_ocid
    description = "Access to on-premise network."
  }
}

resource "oci_core_route_table" "oco_rt_dmz" {

  compartment_id = var.v_comp_network_ocid
  vcn_id = oci_core_vcn.coc_vcn.id
  display_name = "RT DMZ subnet-cloud.oraontap.com"

  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.oco_intg.id
    description = "DMZ networks route to Internet gateway for Internet"
  }

  route_rules {
    destination = var.v_net_onprem_cidr
    network_entity_id = var.v_drg_ocid
    description = "Access to on-premise network."
  }
}
