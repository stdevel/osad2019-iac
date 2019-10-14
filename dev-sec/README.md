# dev-sec
This lab demonstrates how easily machines can be hardened via the [Dev-Sec framework](https://dev-sec.io) in an automated manner.

## Prerequisites
Please ensure that the following requirements are met:
- your user has a **SSH private/public key pair**
- [InSpec](https://inspec.io) is installed
- Ansible is installed
- Git client is installed

## Steps
The following steps need to be performed:

1. Add SSH public key to machine
2. Clone DevSec Linux Security [Baseline](https://dev-sec.io/baselines/linux/) and [Ansible Remediation Role](https://github.com/dev-sec/ansible-os-hardening)
3. Audit machine via InSpec
4. Remediate machine via Ansible
5. Re-audit machine via InSpec

# Preparation
In order to run the script copy your SSH public key to both the Vagrant VM and the Terraform VM:

```
$ ssh-copy-id localhost -p 2222
$ ssh-copy-id ip_address
```
**Note:** It might be possible, that another port than **2222** was assigned by Vagrant.
Check out by leveraging the ``vagrant ssh-config`` command.

# Scan the machines
Scan the Vagrant VM:

```
$ inspec exec linux-baseline -t ssh://vagrant:vagrant@localhost:2222 --sudo
...
Profile Summary: 27 successful controls, 26 control failures, 1 control skipped
Test Summary: 81 successful, 44 failures, 1 skipped
```

Now, trigger the remediation via Ansible:

```
$ ansible-playbook -i inventory harden.yml
PLAY [wrapper playbook for kitchen testing "ansible-os-hardening" with custom vars for testing] *******************************
...
PLAY RECAP *********************************************************************************************************************
localhost                  : ok=37   changed=0    unreachable=0    failed=0    skipped=27   rescued=0    ignored=0
```

If the Vagrant machine has a different port than **2222** you will need to alter the [inventory](inventory) file:
```
[demo-hosts]
localhost ansible_port=1337 ansible_user=vagrant
```

Re-scan the machine:

```
$ inspec exec linux-baseline -t ssh://vagrant:vagrant@localhost:2222 --sudo
...
Profile Summary: 53 successful controls, 0 control failures, 1 control skipped
Test Summary: 125 successful, 0 failures, 1 skipped
```

In order to harden your VM deployed by Terraform, add an entry to your Ansible [inventory](inventory):

```
IP_ADDRESS ansible_user=vagrant
```

Then, re-run the steps above with customized targets:

```
$ inspec exec linux-baseline -t ssh://vagrant:vagrant@ip_address --sudo
$ ansible-playbook -i inventory harden.yml
$ inspec exec linux-baseline -t ssh://vagrant:vagrant@ip_address --sudo
```

Happy converging!
