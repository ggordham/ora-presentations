
# attach the DRG to the VCN
#
resource "oci_core_drg_attachment" "oco_drg_vcn" {

  drg_id = var.v_drg_ocid

  network_details {
      id = oci_core_vcn.coc_vcn.id
      type = "VCN"
  }

}
