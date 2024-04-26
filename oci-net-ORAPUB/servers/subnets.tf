
# data provider for subnets to use for server references
data "oci_core_subnets" "oco_subnet_proxy" {
    #Required
    compartment_id = var.v_comp_network_ocid
    display_name = "PROXY subnet-cloud.oraontap.com"
}

data "oci_core_subnets" "oco_subnet_dmz" {
    #Required
    compartment_id = var.v_comp_network_ocid
    display_name = "DMZ subnet-cloud.oraontap.com"
}

data "oci_core_subnets" "oco_subnet_app" {
    #Required
    compartment_id = var.v_comp_network_ocid
    display_name = "APP subnet-cloud.oraontap.com"
}

data "oci_core_subnets" "oco_subnet_db" {
    #Required
    compartment_id = var.v_comp_network_ocid
    display_name = "DB subnet-cloud.oraontap.com"
}
