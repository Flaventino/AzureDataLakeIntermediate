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

    ## Data Lake & Apache Ecosystem Compatibility:
    ## - HNS (Hierarchical Namespace) is required for optimized large file operations.
    ## - Ensures compatibility with Apache Hadoop/Spark workloads.
    ## - Supports file-level ACLs, allowing fine-grained permissions like HDFS.
    }