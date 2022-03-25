variable "prefix" {
  description = "The prefix used for all resources in this example"
  default       = "spring-infra-dev01"
}

variable "location" {
  description = "The Azure location where all resources in this example should be created"
  default       = "canadacentral"
}

variable "App_Service_Environment_subnet" {
  description = "The Azure App_Service_Environment subnet creation for app service environment"
  default       = "ilb-ase-dev01"
}


variable "application_Gateway_subnet" {
  description = "The Azure application_Gateway_subnet creation for application gateway"
  default       = "app-gw-dev01"
}


variable "Api_Management_subnet" {
  description = "The Azure Api_Management_subnet creation for APIM"
  default       = "api-mgmt-dev01"
}

