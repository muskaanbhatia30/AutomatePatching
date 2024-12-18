resource "azurerm_resource_group" "rgname" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "virtualnetwork" {
  name                = "${local.environment}-virtualnetwork"
  address_space       = ["10.0.0.0/16"]
  location            = local.location
  resource_group_name = local.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${local.environment}-subnet"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtualnetwork.name
  address_prefixes     = ["10.0.2.0/24"]
}

# public ip 

resource "azurerm_public_ip" "ip" {
  for_each = var.vmdetail
  name                = "${each.value.vmname}-ip"
  location            = local.location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
} 

resource "azurerm_network_security_group" "nsg" {
  for_each = var.vmdetail
  name                = "${each.value.vmname}-nsg"
  location            = local.location
  resource_group_name = local.resource_group_name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                  = "Tcp"
    source_port_range         = "*"
    destination_port_range    = "22"
    source_address_prefix     = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.vmdetail
  name                = "${each.value.vmname}-${local.environment}-nic"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.ip[each.key].id
  }

}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  for_each            = var.vmdetail
  network_interface_id      = azurerm_network_interface.nic[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}




# Generate SSH key pair
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save the private key to a local file
resource "local_file" "private_key" {
  content  = tls_private_key.example.private_key_pem
  filename = "${path.module}/key/vmkey.pem"  # Save to current directory as id_rsa
}

# Save the public key to a local file
resource "local_file" "public_key" {
  content  = tls_private_key.example.public_key_openssh
  filename = "${path.module}/key/vmkey.pub"  # Save to current directory as id_rsa.pub
}



resource "azurerm_linux_virtual_machine" "example" {

  for_each = var.vmdetail

  # create vm  onlyif nic exits 

  depends_on = [ azurerm_network_interface.nic ]

  name                = each.value.vmname
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = var.vmsize
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id,
  ]
  

#  disable_password_authentication = false  # Ensure password-based authentication is enabled
 

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

   admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.example.public_key_openssh
  }

  source_image_reference {


    publisher = each.value.vmpublisher
    offer     = each.value.vmoffer
    sku       = each.value.vmsku
    version   = "latest"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [ name ]
  }

  tags = {
    environment=var.environment
  }


}


