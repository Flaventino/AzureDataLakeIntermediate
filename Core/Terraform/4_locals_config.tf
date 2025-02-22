# # DEFINITION OF SPECIFIC VARIABLES
locals {
    # Creates A Dictionary Of The Key Vault Secrets (set in `main.tf`)
    deployment_credentials = {
        "TerraformerID"     = [var.terraformerClientIdName]
        "TerraformerSecret" = [var.terraformerClientSecretName]
        "SpDeployerID"      = [var.spDeployerClientIdName]
        "SpDeployerSecret"  = [var.spDeployerClientSecretName]
        }

    # Creates A Dictionary (i.e. map) Of The Secrets To Store In The Key Vault
    datalake_client_credentials = {
        "secret1" = [var.datalakeClientIdName,
                     var.datalakeClientIdNameDescription,
                     sensitive(module.DatalakeClientSetup.Credentials["appID"])]
        "secret2" = [var.datalakeClientSecretName,
                     var.datalakeClientSecretNameDescription,
                     sensitive(module.DatalakeClientSetup.Credentials["appSecret"])]
        }

    # Creates A Name List Of The Directories To Create In The Data Lake
    project_directory_name_list = [
        var.projectFlatFilesDirectoryName,
        var.projectParquetFilesDirectoryName]
    }