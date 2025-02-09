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

# PROJECT RESOURCE GROUP DEPLOYMENT
resource "azurerm_resource_group" "projectResourceGroup" {
  provider    = azurerm.terraformer
  name        = var.projectRgName
  location    = var.projectResourcesLocation
  }

# PROJECT DATA LAKE DEPLOYMENT
module "DatalakeSetup" {
  providers                = {
    azurerm = azurerm.terraformer
    }
  # Module variables
  source                   = "./modules/DatalakeSetup"
  projectRgName            = var.projectRgName
  projectDatalakeName      = var.projectDatalakeName
  projectResourcesLocation = var.projectResourcesLocation

  depends_on = [ azurerm_resource_group.projectResourceGroup ]
}