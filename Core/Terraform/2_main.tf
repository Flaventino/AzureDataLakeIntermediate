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




# data "azuread_client_config" "current" {
#   provider     = azuread.terraformer
# }
resource "azuread_application" "datalake_monitor" {
  provider     = azuread.service_principal_deployer
  display_name = "datalake-monitor-sp"
  # owners       = [data.azuread_client_config.current.object_id]
  }

# resource "azuread_service_principal" "datalake_monitor" {
#   provider     = azuread.terraformer
#   client_id    = azuread_application.datalake_monitor.client_id
#   }

#   # Service Principal Password
# resource "azuread_service_principal_password" "datalake_monitor" {
#   provider             = azuread.terraformer
#   service_principal_id = azuread_service_principal.datalake_monitor.id
#   }

# # Key Vault Secret (Optional for storing the secret securely)
# resource "azurerm_key_vault_secret" "datalake_monitor_id" {
#   provider     = azurerm.keyvault
#   key_vault_id = data.azurerm_key_vault.Keyper.id

#   # for_each = local.datalake_client_credentials
#   # name         = each.key
#   # value        = each.value
#   name = var.datalakeClientIdName
#   value = azuread_service_principal.datalake_monitor.id
#   content_type = "blabla1"
#   #attribute = "This secret contains the ${each.key} for the datalake_monitor service principal."
# }

# resource "azurerm_key_vault_secret" "datalake_monitor_secret" {
#   provider     = azurerm.keyvault
#   key_vault_id = data.azurerm_key_vault.Keyper.id

#   # for_each = local.datalake_client_credentials
#   # name         = each.key
#   # value        = each.value
#   name = var.datalakeClientSecretName
#   value = azuread_service_principal_password.datalake_monitor.value
#   content_type = "blabla2"
#   #attribute = "This secret contains the ${each.key} for the datalake_monitor service principal."
# }

# # Role Assignment for the Service Principal
# resource "azurerm_role_assignment" "datalake_monitor_access" {
#   scope                = azurerm_storage_account.your_datalake.id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = azuread_service_principal.datalake_monitor.id
# }