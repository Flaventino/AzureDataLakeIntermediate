from dotenv import dotenv_values
from azure.identity import ClientSecretCredential
from azure.keyvault.secrets import SecretClient

# SECRETS & CREDENTIALS RECOVERY FUNCTIONS
def getenv(passname):
    """
    Returns the secret corresponding to the given password name.

    Checks the specified environment variables (from the project's '.env' file)
    to determine if the provided name exists. If it does then the functions
    returns the corresponding secret, and None otherwise.

    Args:
        passname (str): Name of the secret to retrieve from '.env' file.
    """
    return dotenv_values().get(passname)


def get_secret(secret_name):
    """
    Retrieves a secret from Azure Key Vault based on the provided secret name.

    Args:
        secret_name (str): The name of the secret stored in Azure Key Vault.

    Returns:
        str: The value of the requested secret.
    """

    # INITIALIZATION & BASIC SETTINGS
    # → Credential names used to authenticate with Azure Key Vault
    secret_names = ('TENANT_ID','KEYVAULT_CLIENT_ID', 'KEYVAULT_CLIENT_SECRET')

    # LOAD KEY VAULT CREDENTIAL VALUES FROM `.env` FILE
    kv_creds = ClientSecretCredential(*[getenv(name) for name in secret_names])

    # ESTABLISH KEY VAULT CLIENT CONNECTION
    kv_url = f"https://{getenv('KEYVAULT_NAME')}.vault.azure.net/"
    keyvault = SecretClient(vault_url=kv_url, credential=kv_creds)

    # RETURN THE SECRET VALUE FROM AZURE KEY VAULT
    return keyvault.get_secret(secret_name).value


def get_datalake_credentials():
    """
    Returns the credential object required to connect to the Data Lake.

    Returns:
        ClientSecretCredential: The credential object for authentication.
    """

    # INITIALIZATION & BASIC SETTINGS
    # → Credential names used to retrieve authentication secrets
    secret_names = ('TENANT_ID',
                    'DATALAKE_CLIENT_ID_NAME',
                    'DATALAKE_CLIENT_SECRET_NAME')

    # LOAD CREDENTIAL VALUES FROM `.env` FILE
    secret_values = [getenv(name) for name in secret_names]

    # RETRIEVE CLIENT ID & SECRET FROM AZURE KEY VAULT
    secret_values[1:] = [get_secret(kv_name) for kv_name in secret_values[1:]]

    # RETURN DATALAKE CREDENTIAL OBJECT
    return ClientSecretCredential(*secret_values)