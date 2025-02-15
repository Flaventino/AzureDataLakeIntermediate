# KEY VAULT ACCESS (Using 'keyvault' aliased provider)
data "azurerm_key_vault" "Keyper"{
  provider            = azurerm.keyvault
  name                = var.keyvaultName
  resource_group_name = var.keyvaultRgName
  }

# KEY VAULT SECRETS RETRIEVAL
data "azurerm_key_vault_secret" "KeyperSecrets" {
  # Authentication
  provider     = azurerm.keyvault
  key_vault_id = data.azurerm_key_vault.Keyper.id
  # Secrets retrieval
  for_each     = local.kv_secret_names_map
  name         = each.value
  }

# PROJECT RESOURCE GROUP DEPLOYMENT
resource "azurerm_resource_group" "projectResourceGroup" {
  provider    = azurerm.terraformer
  name        = var.projectRgName
  location    = var.projectResourcesLocation
  }

# PROJECT DATA LAKE DEPLOYMENT
module "DatalakeSetup" {
  # Deployment constraints
  providers                = {azurerm = azurerm.terraformer}
  depends_on               = [azurerm_resource_group.projectResourceGroup]
  # Main module variables
  source                           = "./modules/DatalakeSetup"
  projectRgName                    = var.projectRgName
  projectDatalakeName              = var.projectDatalakeName
  projectResourcesLocation         = var.projectResourcesLocation
  projectDatalakeContainerName     = var.projectDatalakeContainerName
  # Name list of directories to create in the data lake
  projectDirectoryNames            = local.project_directory_name_list
  }