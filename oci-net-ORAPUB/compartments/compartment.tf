

resource "oci_identity_compartment" "Network" {
    # Required parent compartment that this will be created in so using tenancy
    compartment_id = "ocid1.tenancy.oc1..aaaaaaaaokluhtlkshbr2rn4znqewtdy5qwomgyxv3j46hlxiauhknaas7oq"
    description = "Owns all network components"
    name = "Network"
}

resource "oci_identity_compartment" "Servers" {
    # Required parent compartment that this will be created in so using tenancy
    compartment_id = "ocid1.tenancy.oc1..aaaaaaaaokluhtlkshbr2rn4znqewtdy5qwomgyxv3j46hlxiauhknaas7oq"
    description = "Compartment for servers"
    name = "Servers"
}
