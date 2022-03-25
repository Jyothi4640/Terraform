provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "spring" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
}

resource "azurerm_api_management" "apim_service" {
  name                = "${var.name}-apim-service"
  location            = "${azurerm_resource_group.apim.location}"
  resource_group_name = "${azurerm_resource_group.apim.name}"
  publisher_name      = "${publisher_name}"
  publisher_email     = "${publisher_email}"
  sku_name            = "Developer_1"
  tags = {
    Environment = "${var.tags}"
  }
  policy {
    xml_content = <<XML
    <policies>
      <inbound />
      <backend />
      <outbound />
      <on-error />
    </policies>
XML
  }
}