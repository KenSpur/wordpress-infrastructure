locals {
  mysqldb_vm_name = "vm-${var.infix}-mysqldb-${var.env}"
}

# public IP address
resource "azurerm_public_ip" "mysqldb" {
  name                = "pip-${var.infix}-mysqldb-${var.env}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
}

# network interface
resource "azurerm_network_interface" "mysqldb" {
  name                = "nic-${var.infix}-mysqldb-${var.env}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.backend.id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.mysqldb.id
  }
}

# image
data "azurerm_shared_image_version" "mysqldb" {
  name                = var.mysqldb_image_version
  image_name          = var.mysqldb_image_name
  gallery_name        = var.image_gallery_name
  resource_group_name = var.image_resource_group_name
}

# virtual machine
resource "azurerm_linux_virtual_machine" "mysqldb" {
  name                = local.mysqldb_vm_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  size                = "Standard_B1s"

  network_interface_ids = [azurerm_network_interface.mysqldb.id]

  computer_name  = local.mysqldb_vm_name
  admin_username = var.ssh_username
  admin_password = var.ssh_password

  disable_password_authentication = false

  source_image_id = data.azurerm_shared_image_version.mysqldb.id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
}