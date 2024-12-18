module "vm" {
    source = "./LinuxVirtualMachine"
    environment=var.environment
    location=var.location
    resource_group_name=var.resource_group_name
    vmsize=var.vmsize
    vmdetail=var.vmdetail
}







