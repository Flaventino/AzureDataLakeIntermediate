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

# LOAD CREDENTIALS INTO SHELL SESSION
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
export "TF_VAR_terraformerClientIdName=${TERRAFORMER_CLIENT_ID_NAME}"
export "TF_VAR_terraformerClientSecretName=${TERRAFORMER_CLIENT_SECRET_NAME}"

#SECRET NAMES
# echo "Variables exportées"