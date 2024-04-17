# Source from https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains

# include our base module information

# Tenancy is the root or parent to all compartments.
# For this tutorial, use the value of <tenancy-ocid> for the compartment OCID.

data "oci_identity_availability_domains" "ads" {
  compartment_id = "ocid1.tenancy.oc1..aaaaaaaaokluhtlkshbr2rn4znqewtdy5qwomgyxv3j46hlxiauhknaas7oq"
}
