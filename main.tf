resource "azurerm_resource_group" "ref-rg" {
    name = var.refrg
    location = var.refloc
}
resource "azurerm_virtual_network" "ref-vnet" {
    name = var.refvnet
    location = azurerm_resource_group.ref-rg.location
    resource_group_name = azurerm_resource_group.ref-rg.name
    address_space = var.refaddrespace
}
resource "azurerm_subnet" "ref-subnet" {
name = var.refsubnet
virtual_network_name = azurerm_virtual_network.ref-vnet.name
resource_group_name = var.refrg
address_prefixes = [ "10.8.2.0/24" ]
}
resource "azurerm_public_ip" "ref-pubip" {
    name = "mypubip"
    resource_group_name = azurerm_resource_group.ref-rg.name
    location = azurerm_resource_group.ref-rg.location
    allocation_method = "Dynamic"
    }

resource "azurerm_network_interface" "ref-nic"{
    name = "nic2805"
    resource_group_name = azurerm_resource_group.ref-rg.name
    location = azurerm_resource_group.ref-rg.location
    ip_configuration {
    name = "mynic-config"
    subnet_id = azurerm_subnet.ref-subnet.id
    private_ip_address_allocation = "Dynamic"
     public_ip_address_id = azurerm_public_ip.ref-pubip.id
    }
}

resource "azurerm_network_security_group" "ref-nsg" {
    name = "mynsg"
    location = azurerm_resource_group.ref-rg.location
    resource_group_name = azurerm_resource_group.ref-rg.name
    security_rule {
    name                       = "rdp"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }  
  
}
resource "azurerm_virtual_machine" "ref-vm1"{
  name                  = "myVM1"
  location              = azurerm_resource_group.ref-rg.location
  resource_group_name   = azurerm_resource_group.ref-rg.name
  network_interface_ids = [azurerm_network_interface.ref-nic.id]
  vm_size  = "Standard_DS1_v2"

  storage_os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    managed_disk_type = "Standard_LRS"
     create_option     = "FromImage"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-datacenter-gensecond"
    version   = "latest"
  }
os_profile {
  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  admin_password                  =  "Passw0rd@123"

}
  os_profile_windows_config {
      
    }
}
