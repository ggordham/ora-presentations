# cloud.oraontap.com variables
# for setup of network

# Compartment information
# once you build your compartments these IDs will be provided
#
v_comp_network_ocid = "ocid1.compartment.oc1..aaaaaaaaiz3jxjk6sko6r3urn6a2zyam56nrus7qkcpqrqcsyzv734rodmwa"
v_comp_servers_ocid = "ocid1.compartment.oc1..aaaaaaaac2ydbfy3j35fxi2cl2yj3rykzk6drqeiaefqxhuxvhrenulobdmq"

# DR OCID to attach VCN to
#
v_drg_ocid = "ocid1.drg.oc1.us-chicago-1.aaaaaaaagjzemkqxqhygukoyv5tzfki4g3ruojzl5y5evtdtmdw4s3wpq2oa"

# Network information
# these are based on your network layout
#
v_net_vcn_oraontap_cidr      = "10.202.202.0/24"
v_net_sn_db_oraontap_cidr    = "10.202.202.128/26"
v_net_sn_app_oraontap_cidr   = "10.202.202.64/26"
v_net_sn_dmz_oraontap_cidr   = "10.202.202.32/27"
v_net_sn_proxy_oraontap_cidr = "10.202.202.0/27"
v_net_onprem_cidr            = "192.168.0.0/24"


