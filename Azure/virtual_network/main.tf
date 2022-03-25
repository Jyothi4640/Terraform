provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "spring" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "springvnet" {
  name                = "${var.prefix}-vnet"
  resource_group_name = "${azurerm_resource_group.spring.name}"
  location            = "${azurerm_resource_group.spring.location}"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "frontend" {
  name                 = "${var.prefix}-frontend-snet"
  virtual_network_name = "${azurerm_virtual_network.springvnet.name}"
  resource_group_name  = "${azurerm_resource_group.spring.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "backend" {
  name                 = "${var.prefix}-backend-snet"
  virtual_network_name = "${azurerm_virtual_network.springvnet.name}"
  resource_group_name  = "${azurerm_resource_group.spring.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_subnet" "database" {
  name                 = "${var.prefix}-database-snet"
  virtual_network_name = "${azurerm_virtual_network.springvnet.name}"
  resource_group_name  = "${azurerm_resource_group.spring.name}"
  address_prefix       = "10.0.3.0/24"
}

resource "azurerm_network_security_group" "springnsg" {
  name                = "${var.prefix}-nsg"
  resource_group_name = "${azurerm_resource_group.spring.name}"
  location            = "${azurerm_resource_group.spring.location}"
}

# NOTE: this allows SSH from any network
resource "azurerm_network_security_rule" "ssh" {
  name                        = "ssh"
  resource_group_name         = "${azurerm_resource_group.spring.name}"
  network_security_group_name = "${azurerm_network_security_group.springnsg.name}"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}