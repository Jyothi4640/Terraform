provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "springapp" {
  name     = "${var.prefix}"
  location = "${var.location}"
}

resource "azurerm_app_service_plan" "spring" {
  name                = "${var.prefix}-appplan"
  location            = "data.azurerm_resource_group.springapp.location"
  resource_group_name = "data.azurerm_resource_group.springapp.name"
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "spring" {
  name                = "${var.prefix}-appservice"
  location            = "data.azurerm_resource_group.springapp.location"
  resource_group_name = "data.azurerm_resource_group.springapp.name"
  app_service_plan_id = "${azurerm_app_service_plan.spring.id}"

  site_config {
    java_version             = "1.8.0_181"
	scm_type                 = "LocalGit"
  }
}
