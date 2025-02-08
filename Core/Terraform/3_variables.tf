# PRECAUTIONS FOR USE & CHANGE
# !!  Dependencies with `<project_root>/Core/Credentials/set_azure_env.sh`  !!

# MAIN CREDENTIALS
## Azure account connection
variable "tenantID" {
  type        = string
  sensitive   = true
  description = "Azure Tenant's unique identification code."
  }

variable "subscriptionID" {
  type        = string
  sensitive   = true
  description = "Azure Subscription's unique identification code."
  }

## Azure key vault connection
variable "keyvaultName" {
  type        = string
  sensitive   = true
  description = "Name of the Key Vault."
  }
variable "keyvaultRgName" {
  type        = string
  sensitive   = true
  description = "Name of the Azure Resource Group containing the Key Vault."
  }
variable "keyvaultClientID" {
  type        = string
  sensitive   = true
  description = "Client ID of the service principal with Key Vault access."
  }

variable "keyvaultClientSecret" {
  type        = string
  sensitive   = true
  description = "Client secret of the service principal with Key Vault access."
  }


# AUXILIARY CREDENTIALS (secret names securely stored in Key Vault)
variable "terraformerClientIdName" {
  type        = string
  sensitive   = true
  description = "Client ID of the service principal used by Terraform to deploy resources."
  }

variable "terraformerClientSecretName" {
  type        = string
  sensitive   = true
  description = "Client secret of the service principal used by Terraform to deploy resources."
  }

variable "ResourceGroupName" {
  description = "Name of the new resource group"
  type        = string
  default     = "NewResourceGroup"
 }

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "North Europe"
  }