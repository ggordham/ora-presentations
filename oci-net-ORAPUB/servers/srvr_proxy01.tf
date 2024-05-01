

resource "oci_core_instance" "srvr_proxy01" {
    # Required
    # availability domain comes from availability-domains.tf file, we pick the first one in the list
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
    compartment_id = var.v_comp_servers_ocid
    shape = "VM.Standard3.Flex"
    shape_config {
        memory_in_gbs = 2
        ocpus = 1
    }
    source_details {
        source_id = var.v_oel8_image_us_ch
        source_type = "image"
    }

    # Optional
    display_name = "proxy01"
    create_vnic_details {
        subnet_id = data.oci_core_subnets.oco_subnet_proxy.subnets[0].id
        private_ip = var.v_srvr_proxy01_ip
        assign_public_ip = false
        assign_ipv6ip = false
        assign_private_dns_record = false
    }
    metadata = {
        ssh_authorized_keys = file(var.v_srvr_ssh_pub)
    } 
    preserve_boot_volume = false

    # this will copy the install script to the server
    provisioner "file" {
      source = "../scripts/instSquid.sh"
      destination = "/home/opc/instSquid.sh"
      connection {
        type = "ssh"
        host = self.private_ip
        user = "opc"
        private_key = file(var.v_srvr_ssh_key)
      }
    }
    
    # this will copy the config file to the server
    provisioner "file" {
      source = "squid.conf"
      destination = "/home/opc/squid.conf"
      connection {
        type = "ssh"
        host = self.private_ip
        user = "opc"
        private_key = file(var.v_srvr_ssh_key)
      }
    }

    # this will copy the server setup script to the server
    provisioner "file" {
      source = "../scripts/srvrSetup.sh"
      destination = "/home/opc/srvrSetup.sh"
      connection {
        type = "ssh"
        host = self.private_ip
        user = "opc"
        private_key = file(var.v_srvr_ssh_key)
      }
    }
    
    # now run the install script
    provisioner "remote-exec" {
        inline = [
          "/bin/bash /home/opc/instSquid.sh > /home/opc/instSquid.log 2>&1"
        ]
        connection {
          type = "ssh"
          host = self.private_ip
          user = "opc"
          private_key = file(var.v_srvr_ssh_key)
        }
    }

    
}
