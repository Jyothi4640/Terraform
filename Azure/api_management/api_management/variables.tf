variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  default     = "spring-infra-dev01"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default     = "canadacentral"
}

variable "name" {
  description = "The name which should be used for all resources in this example"
  default     = "springinfradev01"
}

variable "publisher_name" {
  description = "The publisher_name which should be used for all resources in this example"
  default     = "Venkat"
}

variable "publisher_email" {
  description = "The prefix which should be used for all resources in this example"
  default     = "jacknfind@gmail.com"
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}