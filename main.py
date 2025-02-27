import shutil
from os.path import normpath, abspath, join, dirname
from Core.Credentials.credentials import getenv
from Core.Downloaders.downloaders import download_country_data
from Core.Downloaders.downloaders import download_amazon_products_data
from Core.Uploaders.azure_uploader import upload_file
from Core.Terraform.management.infra_management import provision


def get_data(country, max_cfiles=None, max_amz_files=None):
    """
    Deploys/updates an Azure infra, collects web data, uploads to a data lake.

    Steps:
    1. Deploys or updates Azure infrastructure using Terraform.
    2. Collects data from specified web sources and stores it locally.
    3. Uploads the collected data to the project's Azure Data Lake.
    4. Delete the collected data loccaly after upload.

    Args:
        country (string): The name of the country to retrieve data for.
        max_cfiles (int):  Maximum number of files per country
                           (default: None for all related files).
        max_amz_files (int): Maximum number of files from huggingface.co
                             (default: None for all related files).

    Returns:
        None
    """

    # INITIALIZATION & BASIC SETTINGS
    temp_dir = abspath(join(dirname(__file__), "./temporary"))
    cont_name = getenv('DATALAKE_CONTAINER_NAME')
    flat_files_dir = getenv('DATALAKE_DIRECTORY_NAME_FOR_FLAT_FILES')
    parquet_files_dir = getenv('DATALAKE_DIRECTORY_NAME_FOR_PARQUET_FILES')

    # PROVISIONING AZURE INFRASTRUCTURE
    provision()

    # DOWNLOADING COUNTRY DATA
    kwargs = dict(country=country, max_file=max_cfiles, dest_folder=temp_dir)
    download_country_data(**kwargs)

    # UPLOADING COUNTRY DATA TO AZURE DATA LAKE
    upload_file(temp_dir, container=cont_name, dir_path=flat_files_dir)
    shutil.rmtree(temp_dir, ignore_errors=True)      # Deletes temporary folder

    # DOWNLOADING COUNTRY DATA
    kwargs = dict(max_file=max_amz_files, dest_folder=temp_dir)
    download_amazon_products_data(**kwargs)

    # UPLOADING AMAZON DATA TO AZURE DATA LAKE
    upload_file(temp_dir, container=cont_name, dir_path=parquet_files_dir)
    shutil.rmtree(temp_dir, ignore_errors=True)      # Deletes temporary folder


if __name__ == '__main__':
    get_data(country='spain', max_cfiles=3, max_amz_files=2)