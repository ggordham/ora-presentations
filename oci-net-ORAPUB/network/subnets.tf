
# cloud.oraontap.com subnets

resource "oci_core_subnet" "oco_subnet_dmz" {

  cidr_block = var.v_net_sn_dmz_oraontap_cidr
  compartment_id = var.v_comp_network_ocid
  vcn_id = oci_core_vcn.coc_vcn.id

  display_name = "DMZ subnet-cloud.oraontap.com"

  route_table_id = oci_core_route_table.oco_rt_dmz.id
  security_list_ids = [ oci_core_security_list.oco_sl_dmz.id ]

  prohibit_internet_ingress = false
  prohibit_public_ip_on_vnic = false

}

resource "oci_core_subnet" "oco_subnet_proxy" {

  cidr_block = var.v_net_sn_proxy_oraontap_cidr
  compartment_id = var.v_comp_network_ocid
  vcn_id = oci_core_vcn.coc_vcn.id

  display_name = "PROXY subnet-cloud.oraontap.com"

  route_table_id = oci_core_route_table.oco_rt_proxy.id
  security_list_ids = [ oci_core_security_list.oco_sl_proxy.id ]

  prohibit_internet_ingress = false
  prohibit_public_ip_on_vnic = false

}

resource "oci_core_subnet" "oco_subnet_app" {

  cidr_block = var.v_net_sn_app_oraontap_cidr
  compartment_id = var.v_comp_network_ocid
  vcn_id = oci_core_vcn.coc_vcn.id

  display_name = "APP subnet-cloud.oraontap.com"

  route_table_id = oci_core_route_table.oco_rt_internal.id
  security_list_ids = [ oci_core_security_list.oco_sl_app.id ]

  prohibit_internet_ingress = false
  prohibit_public_ip_on_vnic = false

}

resource "oci_core_subnet" "oco_subnet_db" {

  cidr_block = var.v_net_sn_db_oraontap_cidr
  compartment_id = var.v_comp_network_ocid
  vcn_id = oci_core_vcn.coc_vcn.id

  display_name = "DB subnet-cloud.oraontap.com"

  route_table_id = oci_core_route_table.oco_rt_internal.id
  security_list_ids = [ oci_core_security_list.oco_sl_db.id ]

  prohibit_internet_ingress = false
  prohibit_public_ip_on_vnic = false

}
