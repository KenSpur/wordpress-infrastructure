locals {
  wordpress_vm_name = "vm-${var.infix}-wordpress-${var.env}"
}

# public IP address
resource "azurerm_public_ip" "wordpress" {
  name                = "pip-${var.infix}-wordpress-${var.env}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

# network interface
resource "azurerm_network_interface" "wordpress" {
  name                = "nic-${var.infix}-wordpress-${var.env}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.frontend.id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.wordpress.id
  }
}

# image
data "azurerm_image" "wordpress" {
  name                = var.wordpress_image_name
  resource_group_name = data.azurerm_resource_group.image.name
}

# virtual machine
resource "azurerm_linux_virtual_machine" "wordpress" {
  name                = local.wordpress_vm_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = "Standard_B1s"

  network_interface_ids = [azurerm_network_interface.wordpress.id]

  computer_name  = local.wordpress_vm_name
  admin_username = var.ssh_username
  admin_password = var.ssh_password

  disable_password_authentication = false

  source_image_id = data.azurerm_image.wordpress.id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
}