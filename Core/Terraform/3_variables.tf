# PRECAUTIONS FOR USE & CHANGE
# !!  Dependencies with `<project_root>/Core/Credentials/set_azure_env.sh`  !!

# MAIN CREDENTIALS
## Azure account connection
variable "tenantID" {
  type        = string
  sensitive   = true
  description = "Azure Tenant's unique identification code."
  }

variable "subscriptionID" {
  type        = string
  sensitive   = true
  description = "Azure Subscription's unique identification code."
  }

## Azure key vault connection
variable "keyvaultName" {
  type        = string
  sensitive   = true
  description = "Name of the Key Vault."
  }
variable "keyvaultRgName" {
  type        = string
  sensitive   = true
  description = "Name of the Azure Resource Group containing the Key Vault."
  }
variable "keyvaultClientID" {
  type        = string
  sensitive   = true
  description = "Client ID of the service principal with Key Vault access."
  }

variable "keyvaultClientSecret" {
  type        = string
  sensitive   = true
  description = "Client secret of the service principal with Key Vault access."
  }


# AUXILIARY CREDENTIALS (secret names securely stored in Key Vault)
## Terraform Authentication For Azure Resources Deployment 
variable "terraformerClientIdName" {
  type        = string
  sensitive   = true
  description = "Key vault secret name for Terraform service principal client ID."
  }

variable "terraformerClientSecretName" {
  type        = string
  sensitive   = true
  description = "Key vault secret name for Terraform service principal client secret."
  }

variable "spDeployerClientIdName" {
  type        = string
  sensitive   = true
  description = "Key vault secret name for service principal client ID with 'application administrator' role on Azure active directory."
  }

variable "spDeployerClientSecretName" {
  type        = string
  sensitive   = true
  description = "Key vault secret name for service principal client secret with 'application administrator' role on Azure active directory."
  }
## Data Lake Authentication For Reading And Writing Files
variable "datalakeClientIdName" {
  type        = string
  sensitive   = true
  description = "Key vault secret name for the data lake service principal client ID."
  }
variable "datalakeClientSecretName" {
  type        = string
  sensitive   = true
  description = "Key vault secret name for the data lake service principal client secret."
  }
# OTHER DATA
## Resource Group Configuration Details
## A distinct resource group dedicated to a a fictitious data science project for instance.
variable "projectRgName" {
  type        = string
  sensitive   = true
  description = "Name of the resource group dedicated to the fictitious project."
  }

variable "projectResourcesLocation" {
  type        = string
  sensitive   = true
  description = "Geographic location for deploying the project's resources."
  }

## Data Lake Configuration Details (only relevant one. For others, see terraform files)
variable "projectDatalakeName" {
  type        = string
  sensitive   = true
  description = "Name of the data lake dedicated to the project."
  }
variable "projectDatalakeContainerName" {
  type        = string
  sensitive   = true
  description = "Name of the storage container within the project's data lake."
  }
variable "projectFlatFilesDirectoryName" {
  type        = string
  sensitive   = false
  description = "Name of the directory within the storage container for flat files."
  }
variable "projectParquetFilesDirectoryName" {
  type        = string
  sensitive   = false
  description = "Name of the directory within the storage container for parquet files."
  }