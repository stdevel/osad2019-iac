// provider definition
provider "vsphere" {
  vsphere_server = "${var.vsphere_server}"
  user		 = "${var.vsphere_user}"
  password	 = "${var.vsphere_password}"

  allow_unverified_ssl = true
}



// VM resource definition
resource "vsphere_virtual_machine" "vm" {
  name             = "${var.vm_hostname}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = "${var.vm_cpus}"
  cpu_hot_add_enabled = true
  cpu_hot_remove_enabled = true
  memory   = "${var.vm_memory}"
  memory_hot_add_enabled = true

  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      dns_server_list = "${var.user_network_dns}"
      dns_suffix_list = "${var.user_network_suffix}"

      linux_options {
        host_name       = "${var.vm_hostname}"
        domain          = "${var.vm_domain}"
      }

      network_interface {
        ipv4_address = "${var.user_network_ip}"
        ipv4_netmask = "${var.user_network_netmask}"
      }

      ipv4_gateway = "${var.user_network_gateway}"
    }
  }

  // dont wait for the network if requested
  wait_for_guest_net_timeout = "${var.wait_network_timeout}"
  wait_for_guest_net_routable = "${var.wait_network_routable}"
}


// data definitions
data "vsphere_datacenter" "dc" {
  name          = "${var.vm_dc}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vm_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "${var.vm_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.user_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.template_name}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}