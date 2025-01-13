# AzureDataLakeIntermediate
The goal of this repository is to explore security, a little deeper, accross azure cloud resources uses.

## First goal
The first try we'gona do is trying to upload files from our local machine to an azure's datalake

## Requirements
### Azure resources & services
* Two service principals
* A resource group that comprises:
    + A keyvault
    + A datalake of "Gen2" type

### Programming & Coding resources
* Python version 3.11 and following python libraries :
    + azure-identity
    + azure-keyvault-secrets
    + azure-storage-blob
* A '.env' file to safely enclose sensitive data
    + File location : <project_root>
    + Sensitive data to fill in the file (respect cases !):
        + `KEYVAULT_NAME            = <your keyvault name>`
        + `DATALAKE_NAME            = <your datalake name>`
        + `KEYVAULT_CLIENT_ID       = <your keyvault client id>`
        + `KEYVAULT_CLIENT_SECRET   = <your keyvault client secret>`
        + `KEYVAULT_TENANT_ID       = <your keyvault tenant id>`

While it is never mandatory to work with a virtual environment,<br>
I personally prefer to manage python libraries more easily and reliably with poetry.<br>
Therefore, if you also use a dependency management tool, `DO NOT FORGET TO SET IT UP`.<br>
That also means, in case of the said tool is poetry, not to forget to run `poetry init` then `poetry install` as well.