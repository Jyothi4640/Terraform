output "resource_group" {
  value = "${azurerm_resource_group.spring.name}"
}

output "virtual_network" {
  value = "${azurerm_virtual_network.springvnet.name}"
}

output "asesubnet" {
  value = "${azurerm_subnet.asesubnet.name}"
}

output "appgwsubnet" {
  value = "${azurerm_subnet.appgwsubnet.name}"
}

output "apimsubnet" {
  value = "${azurerm_subnet.apimsubnet.name}"
}

