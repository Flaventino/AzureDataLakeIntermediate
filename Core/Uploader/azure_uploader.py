import os
from Core.Utils.helpers import get_file_paths
from azure.storage.filedatalake import DataLakeServiceClient
from Core.Credentials.credentials import getenv, get_datalake_credentials

def upload_file(file_path, container, dir_path=None):
    """
    Upload a file from local machine to the datalake of the project.

    Args:
        file_path (str): Full local path to the file to upload to the datalake.
                + Either the full path to a file to upload to the datalake.
                + Or the full path to a local directory (upload all files). 
        container (str): Simply the name of the container in the datalake.
        dir_path (str, optional):
                + Either the full path to the destination directory.
                + Or None (default) to upload the file to the container root.
    """

    # INITIALIZATION & BASIC SETTINGS
    datalake_url = f"https://{getenv('DATALAKE_NAME')}.dfs.core.windows.net/"
    datalake_creds = get_datalake_credentials()

    # IMPELEMENTS DATALAKE CONNECTION INFO
    dl_conn_info = {'account_url': datalake_url, 'credential': datalake_creds}

    # CREATING A DIRECT GATEWAY TO THE EXACT DESTINATION ON THE DATALAKE
    client = DataLakeServiceClient(**dl_conn_info)
    client = client.get_file_system_client(file_system=container)
    client = client.get_directory_client(dir_path) if dir_path else client

    # TRANSFERING FILE(S) TO THE REQUIRED DATALAKE LOCATION (i.e. upload)
    for path in get_file_paths(file_path):
        blob = open(path, "rb").read()
        filename = os.path.basename(path)
        client.get_file_client(filename).upload_data(blob, overwrite=True)