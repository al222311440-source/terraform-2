variable "project_name" {
  description = "Nombre del proyecto (5 a 20 caracteres)."
  type        = string
  validation {
    condition     = length(var.project_name) >= 5 && length(var.project_name) <= 20
    error_message = "El nombre del proyecto debe tener entre 5 y 20 caracteres."
  }
}
variable "environment" {
  description = "Entorno de despliegue."
  type        = string
  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "El entorno debe ser dev, qa o prod."
  }
}
variable "location" {
  description = "Región de Azure."
  type        = string
  default     = "mexicocentral"
}
variable "vnet_address_space" {
  description = "Rangos CIDR de la red virtual."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}
variable "tags" {
  description = "Etiquetas adicionales de los recursos."
  type        = map(string)
  default     = {}
}
