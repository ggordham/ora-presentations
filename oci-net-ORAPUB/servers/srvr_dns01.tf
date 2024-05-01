

resource "oci_core_instance" "srvr_dns01" {
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
    display_name = "dns01"
    create_vnic_details {
        subnet_id = data.oci_core_subnets.oco_subnet_proxy.subnets[0].id
        private_ip = var.v_srvr_dns01_ip
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
      source = "../scripts/instPIHole.sh"
      destination = "/home/opc/instPIHole.sh"
      connection {
        type = "ssh"
        host = self.private_ip
        user = "opc"
        private_key = file(var.v_srvr_ssh_key)
      }
    }
     
    # this will copy the runonce script to the server
    provisioner "file" {
      source = "../scripts/runonce.sh"
      destination = "/home/opc/runonce.sh"
      connection {
        type = "ssh"
        host = self.private_ip
        user = "opc"
        private_key = file(var.v_srvr_ssh_key)
      }
    }
    
    # this will copy the custom.list pihole config file to the server
    provisioner "file" {
      source = "custom.list"
      destination = "/home/opc/custom.list"
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
          "/bin/bash /home/opc/instPIHole.sh PRE > /home/opc/instPIHole.log 2>&1"
        ]
        connection {
          type = "ssh"
          host = self.private_ip
          user = "opc"
          private_key = file(var.v_srvr_ssh_key)
        }
    }

    
}
