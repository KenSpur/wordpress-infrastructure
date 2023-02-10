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
data "azurerm_shared_image_version" "wordpress" {
  name                = var.wordpress_image_version
  image_name          = var.wordpress_image_name
  gallery_name        = var.image_gallery_name
  resource_group_name = var.image_resource_group_name
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

  source_image_id = data.azurerm_shared_image_version.wordpress.id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
}

# availability test
data "azurerm_public_ip" "wordpress" {
  name                = azurerm_public_ip.wordpress.name
  resource_group_name = azurerm_public_ip.wordpress.resource_group_name
}

resource "azurerm_application_insights_standard_web_test" "availability" {
  name                    = "validate-availability"
  resource_group_name     = azurerm_resource_group.main.name
  location                = azurerm_resource_group.main.location
  application_insights_id = azurerm_application_insights.main.id

  geo_locations = ["emea-nl-ams-azr"]
  frequency     = 900
  enabled       = true

  request {
    url       = "http://${data.azurerm_public_ip.wordpress.ip_address}"
    http_verb = "GET"
  }

  validation_rules {
    expected_status_code = 200
    ssl_check_enabled    = false

    content {
      content_match      = "WordPress"
      ignore_case        = true
      pass_if_text_found = true
    }
  }
}