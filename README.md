# osad2019-iac
This repository contains an example workfow for the talk "*Infrastructure as Code in practice*" held at [OSAD 2019](https://osad-munich.org).
It contains several configuration files you can simply use in your environment in order to check-out the things shown in the [presentation](presentation.pdf).

# Workflow
The following steps can be done:
1. Create a CentOS 7 golden image running a web server installed by [Ansible](ansible/) using [Packer](packer/)
2. Deploy a simple CentOS 7 [Vagrant Box](vagrant/) with the same configuration for local tests
3. Provision a golden image instance on a VMware vSphere cluster using [Terraform](terraform/)
4. Harden provioning workloads using the [Dev-Sec framework](dev-sec/)

# Presentation
TODO: will follow very soon...
