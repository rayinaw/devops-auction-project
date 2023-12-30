resource "azurerm_resource_group" "rsg" {
  name     = "qtm-rsg"
  location = "East Asia"
}

resource "azurerm_virtual_network" "example" {
  name                = "rancher-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rsg.location
  resource_group_name = azurerm_resource_group.rsg.name
}

resource "azurerm_subnet" "example" {
  name                 = "rancher-subnet"
  resource_group_name  = azurerm_resource_group.rsg.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "rancher-ip" {
  name                = "rancher-publicip"
  resource_group_name = azurerm_resource_group.rsg.name
  location            = azurerm_resource_group.rsg.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "example" {
  name                = "rancher-nic"
  location            = azurerm_resource_group.rsg.location
  resource_group_name = azurerm_resource_group.rsg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rancher-ip.id
  }
}

resource "azurerm_linux_virtual_machine" "rancher_vm" {
  name                = "rancher"
  resource_group_name = azurerm_resource_group.rsg.name
  location            = azurerm_resource_group.rsg.location
  size                = "Standard_D2_v2"
  admin_username      = "rancher"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  admin_ssh_key {
    username   = "rancher"
    public_key = file("vm.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}