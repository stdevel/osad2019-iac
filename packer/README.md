# Packer
This folder contains a Packer configuration for crafting a CentOS 7 golden image on an VMware vSphere host.

## Prerequisites
In order to build the template, ensure having the following requirements fulfilled:
- [Packer](https://packer.io) is installed
- [packer-builder-vsphere](https://github.com/jetbrains-infra/packer-builder-vsphere/releases) plugin for your platform is installed
- VMware vCenter Server
  - vSphere cluster with at least one host
  - at least one network and datastore
  - CentOS 7 minimal image in a datastore
  - network with direct internet access

## Preparation
Create a JSON file containing the credentials used for connecting to vCenter Server:

```
$ cat credentials-simone.json
{
  "vsphere_username": "simone",
  "vsphere_password": "shittyrobots"
}
```

Adjust the [Packer configuration](centos7-x86_64.json) in order to point to the correct vCenter and vCenter information:

```
    "iso_path": "[MYDATASORE] software\\CentOS\\",
    "iso_file": "CentOS-7-x86_64-Minimal-1810.iso",
    "iso_checksum": "38d5d51d9d100fd73df031ffd6bd8b1297ce24660dc8c13a3b8b4534a4bd291c",
    "iso_checksum_type": "md5",
    "vsphere_server": "vc.giertz.loc",
    "vsphere_datacenter": "shittydc",
    "vsphere_datastore": "shittydatastore",
    "vsphere_cluster": "shittycluster",
    "network": "chadnet",
```

If your network does not offer DHCP, also change the following lines:
```
      "boot_command": [
        "<tab> inst.text inst.ks=hd:fd0:/ks.cfg net.ifnames=0 ip=ip_address:gateway:subnet_mask::eth0:none nameserver=dns<enter><wait>"
      ],
```

In addition, you will also need to alter the [CentOS kickstart file](http/ks.cfg):
```
...
#network  --bootproto=dhcp --device=eth0 --ipv6=auto --activate
network --bootproto=static --device=eth0 --ip=192.168.1.100 --netmask=255.255.255.0 --gateway=192.168.1.254 --nameserver=192.168.1.254 --activate
...
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << _EOF_
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
IPADDR=192.168.1.100
NETMASK=255.255.255.0
GATEWAY=192.168.1.254
DNS1=192.168.1.254
DEFROUTE=yes
IPV4_FAILURE_FATAL=yes
IPV6INIT=no
IPV6_AUTOCONF=no
IPV6_DEFROUTE=no
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=eth0
DEVICE=eth0
ONBOOT=yes
_EOF_
```

## What is Packer doing?
Packer performs the following steps:
1. Login into vCenter Server and connect to cluster node
2. Create a new VM
3. Mount ISO image
4. Move [CentOS kickstart file](http/ks.cfg) to a floppy image
5. Connect floppy image to VM
6. Power-on VM and enter Linux kernel commandline in order to boot CentOS installer in kickstart mode
7. Install CentOS according to kickstart profile
8. Apply [Ansible playbook](../ansible) and clean system
9. Shutdown VM
10. Convert to template

# Creating the template
To create the template, perform the following steps.

Validate the template:
```
$ packer validate centos7-x86_64.json
Template validated successfully.
``` 

Build the template:
```
$ packer build -var-file=credentials-terraform.json centos7-x86_64.json
```

Follow the progress on the command-line and check-out the vSphere vCenter interface.
