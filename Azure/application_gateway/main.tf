provider "azurerm" {
  features {}
}

##################################### Resource Group ################################

resource "azurerm_resource_group" "spring" {
  name     = "${var.prefix}-rg"
  location = "${var.location}"
}

#################################### Azure VirtualNetowork/Subnets/NSG ###############

resource "azurerm_virtual_network" "springvnet" {
  name                = "${var.prefix}-vnet"
  resource_group_name = "${azurerm_resource_group.spring.name}"
  location            = "${azurerm_resource_group.spring.location}"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "asesnet" {
  name                 = "${var.App_Service_Environment_subnet}-snet"
  virtual_network_name = "${azurerm_virtual_network.springvnet.name}"
  resource_group_name  = "${azurerm_resource_group.spring.name}"
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "appgw" {
  name                 = "${var.application_Gateway_subnet}-snet"
  virtual_network_name = "${azurerm_virtual_network.springvnet.name}"
  resource_group_name  = "${azurerm_resource_group.spring.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_subnet" "apim" {
  name                 = "${var.Api_Management_subnet}-snet"
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

######################################### Azure PublicIP creation  #################################

resource "azurerm_public_ip" "appgwpip" {
  name                = "${var.prefix}-pip"
  resource_group_name = azurerm_resource_group.spring.name
  location            = azurerm_resource_group.spring.location
  allocation_method   = "Dynamic"
}

######################################## Azure Application Gateway  ################################

# since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${azurerm_virtual_network.springvnet.name}-beap"
  frontend_port_name             = "${azurerm_virtual_network.springvnet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.springvnet.name}-feip"
  http_setting_name              = "${azurerm_virtual_network.springvnet.name}-be-htst"
  listener_name                  = "${azurerm_virtual_network.springvnet.name}-httplstn"
  request_routing_rule_name      = "${azurerm_virtual_network.springvnet.name}-rqrt"
  redirect_configuration_name    = "${azurerm_virtual_network.springvnet.name}-rdrcfg"
}

resource "azurerm_application_gateway" "spring" {
  name                = "${var.prefix}-appgateway"
  resource_group_name = azurerm_resource_group.spring.name
  location            = azurerm_resource_group.spring.location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.appgw.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgwpip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}
