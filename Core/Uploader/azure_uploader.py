########## BETA VERSION ##########
# LIBRARIES MANAGEMENT
# import os
from azure.identity import ClientSecretCredential
from azure.storage.blob import BlobServiceClient
from azure.keyvault.secrets import SecretClient
from backup.credentials import getenv

# Service principal credentials for sp-keyvault-brief
# # KEYVAULT_CLIENT_ID = os.getenv("KEYVAULT_CLIENT_ID")  # "sp-keyvault-brief" client ID
# # KEYVAULT_CLIENT_SECRET = os.getenv("KEYVAULT_CLIENT_SECRET")  # Secret for "sp-keyvault-brief"
# # KEYVAULT_TENANT_ID = os.getenv("KEYVAULT_TENANT_ID")  # Tenant ID
# KEYVAULT_NAME          = ...
# DATALAKE_NAME          = ...
# KEYVAULT_CLIENT_ID     = ...      # "sp-keyvault-brief" client ID
# KEYVAULT_CLIENT_SECRET = ...      # Secret for "sp-keyvault-brief"
# KEYVAULT_TENANT_ID     = ...      # Tenant ID
print(getenv("KEYVAULT_NAME"))

# # Key Vault and Data Lake details
KEYVAULT_URL            = f"https://{KEYVAULT_NAME}.vault.azure.net/"
DATALAKE_SECRET_NAME    = "datalake"  # Secret name in Key Vault
DATALAKE_CONTAINER_NAME = "data"
DATALAKE_URL            = f"https://{DATALAKE_NAME}.dfs.core.windows.net/"  # URL for the data lake

# # Authenticate with Key Vault to retrieve the Data Lake secret
keyvault_credential = ClientSecretCredential(KEYVAULT_TENANT_ID, KEYVAULT_CLIENT_ID, KEYVAULT_CLIENT_SECRET)
keyvault_client     = SecretClient(vault_url=KEYVAULT_URL, credential=keyvault_credential)

# # Fetch the secret for sp-datalake-brief
# dl_secret = keyvault_client.get_secret(DATALAKE_SECRET_NAME)
datalake_secret = keyvault_client.get_secret(DATALAKE_SECRET_NAME).value

# # Service principal credentials for sp-datalake-brief
# DATALAKE_CLIENT_ID = os.getenv("DATALAKE_CLIENT_ID")  # Client ID for sp-datalake-brief
# DATALAKE_CLIENT_SECRET = datalake_secret  # Secret fetched from Key Vault
# DATALAKE_TENANT_ID = os.getenv("DATALAKE_TENANT_ID")  # Tenant ID
# DATALAKE_CLIENT_ID = ...  # Client ID for sp-datalake-brief
DATALAKE_CLIENT_SECRET = datalake_secret  # Secret fetched from Key Vault
DATALAKE_TENANT_ID = KEYVAULT_TENANT_ID  # Tenant ID

# # Authenticate with the Data Lake
datalake_credential = ClientSecretCredential(DATALAKE_TENANT_ID, DATALAKE_CLIENT_ID, DATALAKE_CLIENT_SECRET)
blob_service_client = BlobServiceClient(account_url=DATALAKE_URL, credential=datalake_credential)

# # Function to upload files to the data lake
# def upload_file_to_datalake(file_path, container_name):
#     blob_client = blob_service_client.get_blob_client(container=container_name, blob=os.path.basename(file_path))
#     with open(file_path, "rb") as file_data:
#         blob_client.upload_blob(file_data, overwrite=True)
#     print(f"Uploaded {file_path} to {container_name}.")

# FUNCTION TEST
# local_file = "example.txt"  # Path to the local file
# upload_file_to_datalake(local_file, DATALAKE_CONTAINER_NAME)