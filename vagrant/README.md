# Vagrant
This folder contains a Vagrantfile for deploying a CentOS 7 VM.

## Prerequisites
Ensure to have the following requirements fulfilled:
- [Vagrant](https://vagrantup.com) installed
- [Oracle VirtualBox](https://virtualbox.org) installed

# Steps
The Vagrantfile configures the following:
- Deploy [CentOS 7 Box](https://app.vagrantup.com/centos/boxes/7)
- Install a basic webserver via Ansible (*[see also Ansible folder](../ansible)*)

# Deploy machine
In order to deploy the machine, execute the following command:

```
$ vagrant up
```
