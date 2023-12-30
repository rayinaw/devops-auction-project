variable "rsgname" {
    type = string
    description = "resource group name"
}

variable "location" {
    type = string
    default = "East Asia"
}

variable "service_principal_name" {
    type = string
}

variable "keyvault_name" {
  type = string
  default = "cluster-spn-keyvault"
}