provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "springAse" {
  name     = "${var.prefix}"
  location = "${var.location}"
}


resource "azurerm_virtual_network" "springasevnet" {
  name                = "${var.prefix}-ase-vnet"
  resource_group_name = "data.azurerm_resource_group.springAse.name"
  location            = "data.azurerm_resource_group.springAse.location"
  address_space       = ["10.0.0.0/16"]
}


resource "azurerm_subnet" "ase" {
  name                 = "${var.prefix}-ase-subnet"
  resource_group_name  = "data.azurerm_resource_group.springAse.name"
  virtual_network_name = "data.azurerm_virtual_network.springAse.name"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "gateway" {
  name                 = "${var.prefix}-gatewaysubnet"
  resource_group_name  = "data.azurerm_resource_group.springAse.name
  virtual_network_name = "${azurerm_virtual_network.springasevnet.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_app_service_environment" "dev01" {
  name                   = "${var.prefix}-ase"
  subnet_id              = "${azurerm_subnet.ase.id}"
  pricing_tier           = "I2"
  front_end_scale_factor = 10
}