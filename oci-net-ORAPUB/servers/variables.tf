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

# server keys
variable "v_srvr_ssh_pub" {
  description = "the generic public SSH key for server access"
  type        = string
  # no default value, provide the path to the PUB key file generated
  # ssh-keygen -t rsa -N "" -b 2048 -C <your-ssh-key-name> -f <your-ssh-key-name>
}

variable "v_srvr_ssh_key" {
  description = "the generic private SSH key for server access"
  type        = string
  # no default value, provide the path to the private key file generated
  # ssh-keygen -t rsa -N "" -b 2048 -C <your-ssh-key-name> -f <your-ssh-key-name>
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

# server specific variables
variable "v_oel8_image_us_ch" {
  description = "Server image for OEL 8 US chicago region"
  type        = string
  # no default value
}

variable "v_srvr_dns01_ip" {
  description = "private IP address for DNS01 server"
  type        = string
  # no default value
}

variable "v_srvr_proxy01_ip" {
  description = "private IP address for PROXY01 server"
  type        = string
  # no default value
}

variable "v_srvr_app01_ip" {
  description = "private IP address for APP01 server"
  type        = string
  # no default value
}

variable "v_srvr_db01_ip" {
  description = "private IP address for DB01 server"
  type        = string
  # no default value
}
