**Patch Management and Snapshot Automation on Azure with Ansible and Terraform**

**Project Overview**

This project automates patch management on Azure VMs by creating snapshots of OS disks  and pre-checks, evidence of the servers using Ansible before patching. The infrastructure is provisioned using Terraform.

**Features**
=> Terraform: Automates the provisioning of Azure VMs, storage accounts, and network configurations
and use the remote state file management for state file
=> Ansible: Provides playbooks to automate the pre-patch snapshot creation of VM disks.
=> Patching: Integrates Ansible to schedule and apply OS patches across all VMs.

**Prerequisites**

* Azure Subscription: Required for creating Azure resources.

* Terraform: Installation of Terraform on your local machine.

* Basic Knowledge of Azure Services: Virtual machines, networking, Storage account (blobs), IAM roles.

* Terraform Skills: Modular Configuration, State Management, Functions, Conditions, and Loops, variable and output Management

* Ansible: Dynamic inventory, Ansible Azure collection, and Ansible playbook to automate patching, pre-checks, and evidence before patching 

* Azure blob storage: You should have a blob container that stores the Terraform state.
