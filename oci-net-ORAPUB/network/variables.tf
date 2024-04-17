# Terraform variables generic for OCI ORAPUB network lab

# provider identity parameters
#
variable "v_tenancy_ocid" {
  description = "tenancy ocid where to create the sources"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

variable "v_user_ocid" {
  description = "ocid of user that terraform will use to create the resources"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

variable "v_private_key_path" {
  description = "path to oci api private key used"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

variable "v_fingerprint" {
  description = "fingerprint of oci api private key"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
}

variable "v_region" {
  description = "the oci region where resources will be created"
  type        = string
  # no default value, asking user to explicitly set this variable's value. see codingconventions.adoc
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
}

# Compartment specific variables
#
variable "v_comp_network_ocid" {
  description = "Network compartment OCID"
  type        = string
  # no default value, obtained once compartment is built
}

variable "v_comp_servers_ocid" {
  description = "Servers compartment OCID"
  type        = string
  # no default value, obtained once compartment is built
}

# DRG that is already existing in the OCI tenancy
#
variable "v_drg_ocid" {
  description = "Existing DRG ocid to attach the VCN to"
  type        = string
  # no default value, obtained once compartment is built
}

# Network specific design variables
#
variable "v_net_vcn_oraontap_cidr" {
  description = "VCN cloud.oraontap.com CIDR"
  type        = string
  # no default value
}

variable "v_net_sn_db_oraontap_cidr" {
  description = "Subnet DB cloud.oraontap.com CIDR"
  type        = string
  # no default value
}

variable "v_net_sn_app_oraontap_cidr" {
  description = "Subnet APP cloud.oraontap.com CIDR"
  type        = string
  # no default value
}

variable "v_net_sn_dmz_oraontap_cidr" {
  description = "Subnet DMZ cloud.oraontap.com CIDR"
  type        = string
  # no default value
}

variable "v_net_sn_proxy_oraontap_cidr" {
  description = "Subnet PROXY cloud.oraontap.com CIDR"
  type        = string
  # no default value
}

variable "v_net_onprem_cidr" {
  description = "Subnet for on-premise network connected by VPN CIDR"
  type        = string
  # no default value
}
