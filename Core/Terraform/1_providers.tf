# DEFINITION OF TERRAFORM SETTINGS
terraform {
    required_version = ">=0.12"

    required_providers {
      azurerm = {
          source  = "hashicorp/azurerm"
          version = "~>3.0"
      }
    }
  }

# LOADING PROVIDERS
## Keyvault access provider
## >>> Works via a service principal with `get` and `reader` roles exclusively.
provider "azurerm" {
  alias           = "keyvault"

  # Authentication strings (credentials)
  tenant_id       = var.tenantID
  client_id       = var.keyvaultClientID
  client_secret   = var.keyvaultClientSecret
  subscription_id = var.subscriptionID

  features {}
  }

## Subscription access provider for ressources deployment
## >>> Works via a service principal with `contributor` role on the subscription.
provider "azurerm" {
  alias           = "terraformer"

  # Authentication strings (credentials)
  tenant_id       = var.tenantID
  client_id       = data.azurerm_key_vault_secret.TerraformerID.value
  client_secret   = data.azurerm_key_vault_secret.TerraformerSecret.value
  subscription_id = var.subscriptionID

  features {}
  }