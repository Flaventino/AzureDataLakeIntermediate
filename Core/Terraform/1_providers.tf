# TERRAFORM CONFIGURATION
terraform {
  required_version = ">=0.12"

  required_providers {
    # Manages Entra ID Resources (i.e. app registrations & service principals).
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.0"
      }
    # Manages Azure resources (excluding Entra ID).
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
      }
    }
  }


# KEY VAULT PROVIDER CONFIGURATION
provider "azurerm" {
  alias           = "keyvault"
  # Authentication Credentials
  tenant_id       = var.tenantID
  client_id       = var.keyvaultClientID
  client_secret   = var.keyvaultClientSecret
  subscription_id = var.subscriptionID

  # Key Vault Settings
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = false
      }
    }
  }


# PROVIDER CONFIGURATION FOR SUBSCRIPTION-LEVEL DEPLOYMENTS
provider "azurerm" {
  alias           = "terraformer"
  # Authentication strings (credentials)
  tenant_id       = var.tenantID
  client_id       = module.Keyvault.KeyperSecrets["TerraformerID"].value
  client_secret   = module.Keyvault.KeyperSecrets["TerraformerSecret"].value
  subscription_id = var.subscriptionID

  features {}
  }


# PROVIDER CONFIGURATION FOR ACTIVE DIRECTORY RESOURCE DEPLOYMENTS
provider "azuread" {
  alias           = "service_principal_deployer"
  # Authentication strings (credentials)
  tenant_id       = var.tenantID
  client_id       = module.Keyvault.KeyperSecrets["SpDeployerID"].value
  client_secret   = module.Keyvault.KeyperSecrets["SpDeployerSecret"].value
  }