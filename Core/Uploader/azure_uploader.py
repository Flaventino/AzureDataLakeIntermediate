import os
from azure.storage.filedatalake import DataLakeServiceClient
from Core.Credentials.credentials import getenv, get_datalake_credentials

def upload_file(file_path, container, dir_path=None):
    """
    Upload a file from local machine to the datalake of the project.

    Args:
        file_path (str): Full local path to the file to upload to the datalake.
        container (str): Simply the name of the container in the datalake.
        dir_path (str, optional):
                + Either the full path to the destination directory.
                + Or None (default) to upload the file to the container root.
    """

    # INITIALIZATION & BASIC SETTINGS
    blob = open(file_path, "rb").read()
    filename = os.path.basename(file_path)
    datalake_url = f"https://{getenv('DATALAKE_NAME')}.dfs.core.windows.net/"
    datalake_creds = get_datalake_credentials()

    # IMPELEMENTS DATALAKE CONNECTION INFO
    dl_conn_info = {'account_url': datalake_url, 'credential': datalake_creds}

    # CREATING A DIRECT GATEWAY TO THE EXACT DESTINATION ON THE DATALAKE
    client = DataLakeServiceClient(**dl_conn_info)
    client = client.get_file_system_client(file_system=container)
    client = client.get_directory_client(dir_path) if dir_path else client

    # TRANSFERING FILE TO THE REQUIRED DATALAKE LOCATION (i.e. upload)
    client.get_file_client(filename).upload_data(blob, overwrite=True)

# Test
upload_file('/home/user/AzureDataLakeIntermediate/pyproject.toml', getenv('DATALAKE_CONTAINER_NAME'))