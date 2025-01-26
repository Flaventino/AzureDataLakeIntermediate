# AzureDataLakeIntermediate
The goal of this repository is to explore security, a little deeper, accross azure cloud resources uses.

## First goal
The first try we'gona do is trying to upload files from our local machine to an azure's datalake.<br>
For ease we will consider only a single one data lake as well as only a single one keyvault all accross this project.<br>
Thus Any interacction with a keyvault or a datalake will allways be with the same keyvault of datalake exclusively.

## Requirements
### Azure resources & services
* Two service principals each one with its own configured secret.
    + One in charge to secure keyvault access and querrying.<br>
    To do so, ensure yourself to go to the "access policies" section of the keyvault<br>
    in order to grant a "get" access only of this service principal over the keyvault. 
    + One for monitoring secure access to the data lake.
    So, once the service principal is in place, do not forget to give it a "Storage Blob Data Contributor" role.
    To do so, simply go to the datalake, under "Access control (IAM)", select "add" then the role and select the service principal. 

* An azure resource group that comprises:
    + A keyvault whose access configuration is set on "Access Policy". Securely enclose the following inside:
        + The application ID of the service principal responsible for monitoring access to the data lake
        + The secret value of the service principal responsible for monitoring access to the data lake
    
    + A datalake of "Gen2" type with one container at least. You also can create a directory within that container if you whish.

### Programming & Coding resources
* Python version 3.11 and following python libraries :
    + azure-identity
    + azure-keyvault-secrets
    + azure-storage-blob
    + python-dotenv
    + beautifulsoup4
    + scrapy
* A '.env' file to safely enclose sensitive data.
    + File location : <project_root>/Core/Credentials/.env
    + Sensitive data to add to the file (Be careful, respect the case!):
        + `TENANT_ID                  = <your-tenant-id>`
            - The unique Tenant ID of your Azure Active Directory (AAD) instance.<br>
            This identifies your organization’s Azure AD directory.<br>
            To find it, go to Azure Active Directory (Nowadays look for 'Entra ID') > Overview > Tenant ID in the Azure portal.
        + `KEYVAULT_NAME               = <your-keyvault-name>`
            - The name of your Azure Key Vault instance. This is the unique identifier for your Key Vault in Azure.
        + `KEYVAULT_CLIENT_ID          = <your-service-principal-client-id>`
            - The Application ID of the service principal that is responsible for securing access to your Azure Key Vault.<br>
            The service principal is an identity used by your application to authenticate and interact with Azure resources securely.
        + `KEYVAULT_CLIENT_SECRET      = <your-service-principal-client-secret>`
            - The secret associated with the service principal for authenticating access to your Azure Key Vault.<br>
            This is generated when you create or configure your service principal in Azure.
        + `DATALAKE_NAME               = <your-datalake-name>`
        + `DATALAKE_CLIENT_ID          = <secret-name-under-which-you-enclosed-the-service-principal-application-id>`
            - The Application ID of the service principal that is responsible for securing write access to your datalake.<br>
        + `DATALAKE_CONTAINER_NAME     = <the-name-of-the-target-container-within-your-datalake>`
        + `DATALAKE_CLIENT_SECRET_NAME = <secret-name-under-which-you-enclosed-the-service-principal-client-secret>`
            - The secret associated with the service principal for authenticating write access to your datalake.<br>`

While it is never mandatory to work with a virtual environment,<br>
I personally prefer to do it in order to manage python libraries & dependencies more easily and reliably with poetry.<br>
Therefore, if you also use a dependency management tool, then **DO NOT FORGET TO SET IT UP**.<br>
That also means, in case of the said tool is poetry, not to forget to run `poetry init` then `poetry install` as well.