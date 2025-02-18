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
  depends_on               = [azurerm_resource_group.projectResourceGroup,
                              azuread_service_principal.datalake_monitor_sp
                             ]
  # Main module variables
  source                       = "./modules/DatalakeSetup"
  projectRgName                = var.projectRgName
  projectDatalakeName          = var.projectDatalakeName
  projectResourcesLocation     = var.projectResourcesLocation
  projectDatalakeContainerName = var.projectDatalakeContainerName
  # Name list of directories to create in the data lake
  projectDirectoryNames        = local.project_directory_name_list
  servicePrincipalID           = azuread_service_principal.datalake_monitor_sp.object_id
  }

# DEPLOYMENT OF THE SERVICE PRINCIPAL THAT WILL MONITOR THE DATA LAKE ACCESS
## Creates first a new `app registration` (exactly as we would do on the portal)
resource "azuread_application" "datalake_monitor" {
  provider     = azuread.service_principal_deployer
  display_name = "datalake-monitor-sp"
  }

## Creates a password for the new app registration created right above
resource "azuread_application_password" "datalake_monitor_sp_secret" {
  provider     = azuread.service_principal_deployer
  display_name = "datalake-monitor-secret"
  application_id = azuread_application.datalake_monitor.id
  }

## Finally creates the required service principal (for datalake secure access purpose)
resource "azuread_service_principal" "datalake_monitor_sp" {
  provider  = azuread.service_principal_deployer
  client_id = azuread_application.datalake_monitor.client_id
  }

# SECURE STORAGE OF SERVICE PRINCIPAL CREDENTIALS
resource "azurerm_key_vault_secret" "datalake_monitor_id" {
  provider     = azurerm.keyvault
  key_vault_id = data.azurerm_key_vault.Keyper.id

  # for_each = local.datalake_client_credentials
  # name         = each.key
  # value        = each.value
  name = var.datalakeClientIdName
  value = azuread_application.datalake_monitor.id
  content_type = "DatalakeClientId"
  }
resource "azurerm_key_vault_secret" "datalake_monitor_secret" {
  provider     = azurerm.keyvault
  key_vault_id = data.azurerm_key_vault.Keyper.id

  # for_each = local.datalake_client_credentials
  # name         = each.key
  # value        = each.value
  name = var.datalakeClientSecretName
  value = azuread_application_password.datalake_monitor_sp_secret.value
  content_type = "DataLakeClientSecret"
  }