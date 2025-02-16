# DEFINITION OF SPECIFIC VARIABLES
locals {
    # Creates a Dictionary Of the Key Vault Secrets (set in `main.tf`)
    kv_secret_names_map = {
        "TerraformerID"     = var.terraformerClientIdName
        "TerraformerSecret" = var.terraformerClientSecretName
        "SpDeployerID"      = var.spDeployerClientIdName
        "SpDeployerSecret"  = var.spDeployerClientSecretName
        }
    
    # Creates A Name List Of The Directories To Create In The Data Lake
    project_directory_name_list = [
        var.projectFlatFilesDirectoryName,
        var.projectParquetFilesDirectoryName
        ]
    # Creates A Dictionary Of Secrets to Store in The Key Vault (set in `main.tf`)
    # datalake_client_credentials = {
    #     "${var.datalakeClientIdName}"     = azuread_service_principal.datalake_monitor.id
    #     "${var.datalakeClientSecretName}" = azuread_service_principal_password.datalake_monitor.value
    #     }
    }