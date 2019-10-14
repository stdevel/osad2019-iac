# Deploy a new Linux machine from template

This terraform configuration deploys a new Linux machine from a template (*the one we built with [Packer](../packer/).

# Prerequisites
Ensure to have the following requirements fulfilled:
- [Terraform](https://terraform.io) is installed
- VMware vCenter Server
  - vSphere cluster with at least one host
  - at least one datastore and network

# Preparation
Create a file containing user credentials used for VM provisioning:

```
$ cat credentials-simone.tfvars
vsphere_user = "giertz.loc\\simone"
vsphere_password = "pinkepank"
```

# Example

To start, simply copy the [`demo_vm.tfvars`](demo_vm.tfvars) file and alter it to match the new VM.

The example file looks like this:
```
vm_hostname = "myvm"
user_network_ip = "10.0.0.10"
user_network_gateway = "10.0.0.1"
```

This will deploy a new VM named **myvm** with user network IP address **10.0.0.10** and gateway **10.0.0.1**.

Before deployment, make sure that your Terraform configuration is valid (``validate``). After that, see which changes would be made (``plan``) before actually executing them (``apply``):
```
$ terraform validate -var-file=credentials-simone.tfvars -var-file=demo_vm.tfvars
$ terraform plan -var-file=credentials-simone.tfvars -var-file=demo_vm.tfvars
$ terraform apply -var-file=credentials-simone.tfvars -var-file=demo_vm.tfvars
```

To destroy your VM, run the ``destroy`` subcommand:
```
$ terraform destroy -var-file=credentials-simone.tfvars -var-file=demo_vm.tfvars
```

## Parameters
Refer to the following table for additional parameters:

| Parameter | Default value | Description |
| --------- | ------------- | ----------- |
| ``template_name`` | ``template_centos7`` | VM template to clone |
| ``vm_dc`` | ``shittylab`` | Datacenter to deploy to |
| ``vm_cluster`` | ``shittycluster`` | Cluster to deploy to |
| ``vm_datastore`` | ``shittydatastore`` | Datastore VM will be stored on |
| ``vm_hostname`` | ``terraform-test`` | VM hostname |
| ``vm_domain`` | ``giertz.loc`` | Network domain |
| ``vm_cpus`` | ``2`` | Amount of CPUs |
| ``vm_memory`` | ``2048`` | Amount of memory in MB |
| ``user_network`` | ``chadnet`` | vSphere user network binding |
| ``user_network_ip`` | ``10.0.0.10`` | vSphere user network IP address |
| ``user_network_netmask`` | ``24`` | vSphere user network CIDR |
| ``user_network_gateway`` | ``10.0.0.1`` | vSphere user network gateway |
| ``user_network_dns`` | ``[192.168.1.254, 192.168.1.253]`` | vSphere user network DNS servers |
| ``user_network_suffix`` | ``giertz.loc`` | vSphere user network DNS search suffix |
| ``vsphere_server`` | ``vc.giertz.loc`` | VMware vCenter Server to connect to |
| ``wait_network_timeout`` | ``1`` | Don't abort if IP address has timeouts if set to 0 |
| ``wait_network_routable`` | ``1`` | Don't check whether IP address is pingable if set to 0 |
