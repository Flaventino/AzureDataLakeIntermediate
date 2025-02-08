# KEY VAULT ACCESS (Using 'keyvault' aliased provider)
data "azurerm_key_vault" "Keyper"{
  provider            = azurerm.keyvault
  name                = var.keyvaultName
  resource_group_name = var.keyvaultRgName
  }

# KEY VAULT SECRETS RETRIEVAL
data "azurerm_key_vault_secret" "TerraformerID" {
  provider     = azurerm.keyvault
  name         = var.terraformerClientIdName
  key_vault_id = data.azurerm_key_vault.Keyper.id
  }

data "azurerm_key_vault_secret" "TerraformerSecret" {
  provider     = azurerm.keyvault
  name         = var.terraformerClientSecretName
  key_vault_id = data.azurerm_key_vault.Keyper.id
  }
# RESOURCES DELOYMENT


# CREATES A NEW RESOURCE GROUP SETUP
resource "azurerm_resource_group" "ResourcesGroup" {
    provider    = azurerm.terraformer
    name        = var.ResourceGroupName
    location    = var.location
}