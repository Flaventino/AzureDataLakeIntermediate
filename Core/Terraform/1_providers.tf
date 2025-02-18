# DEFINITION OF TERRAFORM SETTINGS
terraform {
    required_version = ">=0.12"

    required_providers {
      # Provider For Azure Active Directory Resources Management (i.e. Entra ID)
      # >>> In order to manage service principals
      azuread = {
        source  = "hashicorp/azuread"
        version = "~>2.0"
        }
      # Provider For Azure Resources Management (except Entra Id)
      azurerm = {
        source  = "hashicorp/azurerm"
        version = "~>3.0"
        }
      # # Provider For Random Values Generation (Used for srvice principals secrets)
      # random = {
      #   source  = "hashicorp/random"
      #   version = "~>3.0"
      #   }
      }
  }

# LOADING PROVIDERS
## Provider for Key Vault access
## >>> Uses a service principal with 'Reader' and 'Get' roles only.
provider "azurerm" {
  alias           = "keyvault"

  # Authentication strings (credentials)
  tenant_id       = var.tenantID
  client_id       = var.keyvaultClientID
  client_secret   = var.keyvaultClientSecret
  subscription_id = var.subscriptionID

  # Usefull features to add to the provider to enhance its default behavior.
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = false
      }
    }
  }

## Provider for subscription-level resources deployment
## >>> Works using a service principal with the 'Contributor' role at the subscription level.
provider "azurerm" {
  alias           = "terraformer"

  # Authentication strings (credentials)
  tenant_id       = var.tenantID
  client_id       = data.azurerm_key_vault_secret.KeyperSecrets["TerraformerID"].value
  client_secret   = data.azurerm_key_vault_secret.KeyperSecrets["TerraformerSecret"].value
  subscription_id = var.subscriptionID

  features {}
  }

# ## Provider for password generation
# provider "random" {
#   alias = "passwordGenerator"
#   }

## Provider for active-directory-level resources deployment
## >>> Works using a service principal with the 'Application Administrator' role at the active directory level.
provider "azuread" {
  alias           = "service_principal_deployer"

  # Authentication strings (credentials)
  tenant_id       = var.tenantID
  client_id       = data.azurerm_key_vault_secret.KeyperSecrets["SpDeployerID"].value
  client_secret   = data.azurerm_key_vault_secret.KeyperSecrets["SpDeployerSecret"].value
  }