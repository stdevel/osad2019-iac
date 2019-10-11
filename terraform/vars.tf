// VM options
variable "template_name" {
  default = "template_centos7"
}

variable "vm_dc" {
  default = "shittylab"
}

variable "vm_cluster" {
  default = "shittycluster"
}

variable "vm_datastore" {
  default = "shittydatastore"
}

variable "vm_hostname" {
  default = "terraform-test"
}

variable "vm_domain" {
  default = "giertz.loc"
}

variable "vm_cpus" {
  default = 2
}

variable "vm_memory" {
  default = 2048
}

variable "wait_network_timeout" {
  default = 0
}

variable "wait_network_routable" {
  default = true
}


// User network
variable "user_network" {
  default = "chadnet"
}

variable "user_network_ip" {
  default = "192.168.1.10"
}

variable "user_network_netmask" {
  default = 24
}

variable "user_network_gateway" {
  default = "192.168.1.254"
}

variable "user_network_dns" {
  default = [ "192.168.1.254", "192.168.1.253" ]
}

variable "user_network_suffix" {
  default = [ "giertz.loc" ]
}



// credentials
variable "vsphere_server" {
  default = "vc.giertz.loc"
}
variable "vsphere_user" {
  default = "DO_NOT_PASTE_CREDENTIALS_IN_THIS_FILE - CUTE KITTEN WILL DIE"
}
variable "vsphere_password" {
  default = "DO_NOT_PASTE_CREDENTIALS_IN_THIS_FILE - CUTE KITTEN WILL DIE"
}
