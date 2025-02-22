#!/bin/bash

# CONTEXT & PURPOSE OF THIS SCRIPT
# This is a short Bash script designed to load Azure authentication credentials
# from a .env file. The script exports these credentials using the `export`
# command with specific naming conventions, enabling Terraform to automatically
# discover and use them for authenticating with Azure.

# INITIALIZATION & BASIC SETTINGS
CREDS_FILE="$(dirname "${BASH_SOURCE[0]}")/.env"  # Gets full path to .env file

# CHECKING IF THE PATH IS POINTING TO A FILE AND NOT SIMPLY TO A DIRECTCORY
if [[ ! -f "$CREDS_FILE" ]]; then
    echo "Error: .env file not found at $CREDS_FILE"
    exit 1
fi

# LOAD CREDENTIALS & OTHER SENSITIVE INFO INTO SHELL SESSION FROM '.env' FILE
source "$CREDS_FILE"

# VARIABLE EXPORT SECTION
# Caution: Ensure Terraform variable names match these environment variables.

## EXPORT MAIN CREDENTIALS
### EXPORT AZURE ACCOUNT CREDENTIALS
export "TF_VAR_tenantID=${TENANT_ID}"
export "TF_VAR_subscriptionID=${SUBSCRIPTION_ID}"

### EXPORT AZURE KEYVAULT CREDENTIALS
export "TF_VAR_keyvaultName=${KEYVAULT_NAME}"
export "TF_VAR_keyvaultRgName=${KEYVAULT_RESOURCE_GROUP_NAME}"
export "TF_VAR_keyvaultClientID=${KEYVAULT_CLIENT_ID}"
export "TF_VAR_keyvaultClientSecret=${KEYVAULT_CLIENT_SECRET}"

## EXPORT AUXILIARY CREDENTIALS (Secret names securely stored in Key Vault)
### Terraform Authentications For Azure Resources Deployment
#### Service Principal With 'contributor' Role On Current Active Subscription
export "TF_VAR_terraformerClientIdName=${TERRAFORMER_CLIENT_ID_NAME}"
export "TF_VAR_terraformerClientSecretName=${TERRAFORMER_CLIENT_SECRET_NAME}"
#### Service Principal With 'application administrator' Role On Azure Active Directory
export "TF_VAR_spDeployerClientIdName=${SP_DEPLOYER_CLIENT_ID_NAME}"
export "TF_VAR_spDeployerClientSecretName=${SP_DEPLOYER_CLIENT_SECRET_NAME}"
### Data Lake Authentication For Reading And Writing Files
export "TF_VAR_datalakeClientIdName=${DATALAKE_CLIENT_ID_NAME}"
export "TF_VAR_datalakeClientSecretName=${DATALAKE_CLIENT_SECRET_NAME}"

## EXPORT OTHER CONFIGURATION DATA
## Project Dedicated Resource Group Configuration Details (data science project for instance)
export "TF_VAR_projectRgName=${PROJECT_RESOURCE_GROUP_NAME}"
export "TF_VAR_projectResourcesLocation=${PROJECT_RESOURCE_GROUP_LOCATION}"
## Data Lake Configuration Details
export "TF_VAR_projectDatalakeName=${DATALAKE_NAME}"
export "TF_VAR_projectDatalakeClientName=${DATALAKE_CLIENT_NAME}"
export "TF_VAR_projectDatalakeContainerName=${DATALAKE_CONTAINER_NAME}"
export "TF_VAR_projectFlatFilesDirectoryName=${DATALAKE_DIRECTORY_NAME_FOR_FLAT_FILES}"
export "TF_VAR_projectParquetFilesDirectoryName=${DATALAKE_DIRECTORY_NAME_FOR_PARQUET_FILES}"
## Keyvault Secret Descriptions
export "TF_VAR_datalakeClientIdNameDescription=${DATALAKE_CLIENT_ID_NAME_DESCRIPTION}"
export "TF_VAR_datalakeClientSecretNameDescription=${DATALAKE_CLIENT_SECRET_NAME_DESCRIPTION}"