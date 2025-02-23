# RETRIEVING CREDENTIALS FROM KEY VAULT FOR PROVIDER INITIALIZATION
module "Keyvault" {
    # Deployment constraints
    source                   = "./modules/Keyvault"
    providers                = {azurerm = azurerm.keyvault}
    # Main module variables
    action                   = "get"
    keyvaultName             = var.keyvaultName
    keyvaultRgName           = var.keyvaultRgName
    kvSecretsMap             = local.deployment_credentials
    }


# DATALAKE CLIENT DEPLOYMENT
module "DatalakeClientSetup" {
  # Deployment constraints
  source     = "./modules/ClientSetup"
  providers  = {azuread = azuread.service_principal_deployer}
  # Main module variables
  appRegistrationName = var.projectDatalakeClientName
  }

# STORING THE DATA LAKE CLIENT CREDENTIALS IN KEY VAULT
module "DatalakeClientCredentialsSaving" {
    # Deployment constraints
    source                   = "./modules/Keyvault"
    providers                = {azurerm = azurerm.keyvault}
    # Main module variables
    action                   = "set"
    keyvaultName             = var.keyvaultName
    keyvaultRgName           = var.keyvaultRgName
    kvSecretsMap             = local.datalake_client_credentials
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
  source     = "./modules/DatalakeSetup"
  providers  = {azurerm = azurerm.terraformer}
  depends_on = [azurerm_resource_group.projectResourceGroup]#,
                # azuread_service_principal.datalake_monitor_sp]
  # Main module variables
  projectRgName                = var.projectRgName
  projectDatalakeName          = var.projectDatalakeName
  projectResourcesLocation     = var.projectResourcesLocation
  projectDatalakeContainerName = var.projectDatalakeContainerName
  # Name list of directories to create in the data lake
  projectDirectoryNames        = local.project_directory_name_list
  servicePrincipalID           = sensitive(module.DatalakeClientSetup.Credentials["clientObjectID"])
  }