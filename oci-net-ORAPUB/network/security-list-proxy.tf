
# Source from https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list

resource "oci_core_security_list" "oco_sl_proxy"{

# Required
  compartment_id = var.v_comp_network_ocid
  vcn_id = oci_core_vcn.coc_vcn.id


# Optional
  display_name = "SL PROXY subnet-cloud.oraontap.com"
  
  egress_security_rules {
      stateless = false
      destination = "0.0.0.0/0"
      destination_type = "CIDR_BLOCK"
      protocol = "all" 
  }


  # allow proxy server access from internal subnets
  ingress_security_rules { 
      description = "Allow PROXY access from internal subnets only"
      stateless = false
      source = var.v_net_vcn_oraontap_cidr
      source_type = "CIDR_BLOCK"
      # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml TCP is 6
      protocol = "6"
      tcp_options { 
          min = 3128
          max = 3128
      }
  }

  # allow ping from internal subnets
  ingress_security_rules { 
      description = "Allow ping access from all internal subnets"
      stateless = false
      source = var.v_net_vcn_oraontap_cidr
      source_type = "CIDR_BLOCK"
      # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml ICMP is 1  
      protocol = "1"
  
      # For ICMP type and code see: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
      icmp_options {
        type = 3
        code = 4
      } 
  }   
  
  ingress_security_rules { 
      description = "Allow ping access from all internal subnets"
      stateless = false
      source = var.v_net_vcn_oraontap_cidr
      source_type = "CIDR_BLOCK"
      # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml ICMP is 1  
      protocol = "1"
  
      # For ICMP type and code see: https://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml
      icmp_options {
        type = 3
      } 
  }

  # allow on premise all access
  ingress_security_rules { 
      description = "Allow on-premise network all access"
      stateless = false
      source = var.v_net_onprem_cidr
      source_type = "CIDR_BLOCK"
      # Get protocol numbers from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml TCP is 6
      protocol = "all"
    }

}

