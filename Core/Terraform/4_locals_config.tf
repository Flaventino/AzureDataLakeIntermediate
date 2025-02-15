# DEFINITION OF SPECIFIC VARIABLES
locals {
    # Creatses a Dictionary Of the Key Vault Secrets (set in `main.tf`)
    kv_secret_names_map         = {
        "TerraformerID"     = var.terraformerClientIdName
        "TerraformerSecret" = var.terraformerClientSecretName
        }
    # Creates AName List Of The Directories To Create In The Data Lake
    project_directory_name_list = [
        var.projectFlatFilesDirectoryName,
        var.projectParquetFilesDirectoryName]
    }