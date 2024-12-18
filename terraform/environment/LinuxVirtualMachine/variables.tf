
variable "environment" {
    description = "name of environment i.e prod or nonprod"
    type = string
    default = "nonprod"
    nullable = false
  
}
variable "resource_group_name" {
  description = "resource group name "
  type = string
}

variable "location" {
  description = "location of resource group"
  default = "north europe"
  type = string
  nullable = false
}



# virtual machine 


variable "vmdetail" {
  type = map(object({
    vmname=string
    vmpublisher=string
    vmoffer=string
    vmsku=string
  }))
  nullable = false
  
}

variable "vmsize" {
  description = "virtual machine size"
  type = string
  nullable = false
}


# variable "vmpublisher" {
#   description = "virtual machine publisher can be Canonical(ubuntu), MicrosoftWindowsServer (Windows),RedHat(RHEL),OpenLogic(CentOS),SUSE"
#   type = string
#   nullable = false
# }

# variable "vmoffer" {
#   description = "virtual machine product version"
#   type = string
#   nullable = false
# }



# variable "vmsku" {
#   description = "(20_04-lts)for Ubuntu 20.04 LTS,(18_04-lts) for Ubuntu 18.04 LTS, (22_04-lts) for Ubuntu 22.04 LTS"
#   type = string
#   nullable = false
# }


