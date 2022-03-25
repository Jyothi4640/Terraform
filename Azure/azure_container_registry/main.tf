provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "springAcr" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
}

resource "azurerm_container_registry" "spring" {
  name                = "${var.name}registry"
  resource_group_name = "${azurerm_resource_group.springAcr.name}"
  location            = "${azurerm_resource_group.springAcr.location}"
  sku                 = "Basic"
  
  tags                = "${var.tags}"
}