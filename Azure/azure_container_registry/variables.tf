variable "prefix" {
  description = "The prefix used for all resources in this example"
  value       = "spring-infra-dev01"
}

variable "name" {
  description = "The prefix used for all resources in this example"
  value       = "springdev01"
}

variable "location" {
  description = "The Azure location where all resources in this example should be created"
  value       = "canadacentral"
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}