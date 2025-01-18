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
    Returns a secret from the keyvault corresponding to the given secret name.

    Args:
        secret_name (str): Name under which a secret is stored in the keyvault.
    """

    # GET KEYVAULT CREDENTIALS
    labels = ['TENANT_ID', 'KEYVAULT_CLIENT_ID', 'KEYVAULT_CLIENT_SECRET']
    kv_creds = ClientSecretCredential(*[getenv(label) for label in labels])

    # GET KEYVAULT ACCESS
    kv_url = f"https://{getenv('KEYVAULT_NAME')}.vault.azure.net/"
    keyvault = SecretClient(vault_url=kv_url, credential=kv_creds)
    
    # FUNCTION OUOTPUT (Required secrcet value from the keyvault)
    return keyvault.get_secret(secret_name).value


def get_datalake_credentials():
    """
    Simply returns the credential object required to connect the datalake.
    No arguments required so far ! 
    """

    # INITIALIZATION & BASIC SETTINGS (i.e. credential secret names)
    secret_names = ('TENANT_ID',
                    'DATALAKE_CLIENT_ID',
                    'DATALAKE_CLIENT_SECRET_NAME')

    # GETS THE CREDENTIAL SECRET VALUES
    secret_values = [getenv(name) for name in secret_names]
    secret_values[1:] = [get_secret(kv_name) for kv_name in secret_values[1:]]

    # FUNCTION OUTPUT (returns the datalake credentials object)
    return ClientSecretCredential(*secret_values)