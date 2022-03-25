variable "location" {
  description = "Azure Region where the gateway will be created"
  default     = "canadacentral"
}

variable "prefix" {
  description = "Root name applied to all resources. A dynamic name will be generated if none is provided"
  default     = "infra-dev01"
}


variable "name" {
  description = "Root name applied to all resources. A dynamic name will be generated if none is provided"
  default     = "infradev01"
}

variable "enable_http2" {
  description = "Enable the HTTP/2 protocol"
  default     = true
}

variable "private_ip_address" {
  description = "The Private IP Address to use for the Application Gateway."
}

variable "cookie_based_affinity" {
  description = "Specify Enabled or Disabled. Controls cookie-based session affinity to backend pool members"
  default     = "Disabled"
}

variable "backend_request_timeout" {
  description = "Number of seconds to wait for a backend pool member to respond"
  default     = 60
}

variable "enable_connection_draining" {
  description = "Enable connection draining to change members within a backend pool without disruption"
  default     = false
}

variable "connection_drain_timeout" {
  description = "Number of seconds to wait before for active connections to drain out of a removed backend pool member"
  default     = 300
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}