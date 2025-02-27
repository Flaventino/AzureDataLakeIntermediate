variable "action" {
  type        = string
  sensitive   = false
  description = "Action to perform on the Key Vault (get/set)"
  }
variable "keyvaultName" {
  type        = string
  sensitive   = true
  description = "Defined in the root module."
  }
variable "keyvaultRgName" {
  type        = string
  sensitive   = true
  description = "Defined in the root module."
  }
variable "kvSecretsMap" {
  type        = map(list(string))
  sensitive   = false
  description = "Map of secrets to either create or retrieve from the keyvault"
  }