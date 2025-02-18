# CREATES A DATALAKE `GEN2` (nothing but a special Azure Storage Account)
resource "azurerm_storage_account" "projectDataLake" {
    # General settings
    name                       = var.projectDatalakeName
    location                   = var.projectResourcesLocation
    resource_group_name        = var.projectRgName

    # Secure access enforcement
    https_traffic_only_enabled = true

    # Performance & redundancy settings (i.e. Data lake capability)
    access_tier                = "Cool"     # 'cold' means less frequent accessed data.
    account_tier               = "Standard" # Standard storage (cheaper in big data scenarios)
    account_replication_type   = "LRS"      # Locally Redundant Storage (cheapest option)

    # Data lake specific characteristics
    # >>> Settings required to upgrade standard storage account into a data lake
    account_kind               = "StorageV2"     # Required for Data Lake Gen2.
    is_hns_enabled             = true            # Hierarchical Name Space for `Gen2`.

    ## Data Lake & Apache Ecosystem Compatibility (Hadoop/Spark particularly):
    ## - HNS (Hierarchical Namespace) is required for optimized large file operations.
    }

# CREATES A CONTAINER IN THE DATA LAKE (required to store files)
resource "azurerm_storage_container" "rawWebDataContainer" {
    name                  = var.projectDatalakeContainerName
    storage_account_name  = azurerm_storage_account.projectDataLake.name
    container_access_type = "private"       # So that files access is not public.
    }

# CREATES DIRECTORIES IN THE DATA LAKE'S CONTAINER (to organize raw data files)
resource "azurerm_storage_data_lake_gen2_path" "containerDirectories" {
    # Batch creation of directories
    for_each = toset(var.projectDirectoryNames)
    path     = each.value           # Allow multiple directories to be created.
    
    # Common settings for all directories
    resource             = "directory"    # Resource type. So 'directory' here!
    filesystem_name      = azurerm_storage_container.rawWebDataContainer.name
    storage_account_id   = azurerm_storage_account.projectDataLake.id
    }

# CONFIGURING DATA LAKE ACCESS CONTROL
resource "azurerm_role_assignment" "datalake_monitor_access" {
    scope                = azurerm_storage_account.projectDataLake.id
    role_definition_name = "Storage Blob Data Contributor"
    principal_id         = var.servicePrincipalID
    }