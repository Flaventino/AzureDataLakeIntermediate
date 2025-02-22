# AzureDataLakeIntermediate
The goal of this repository is to explore security concepts and implementation on Azure and accross azure cloud resources uses.

## Repository goals
## Abstract
We place ourselves within a fictive data science project whose first ever stage is simply to collect data to wkorn on. Within such a context we're gona play the role of a data engineer in charge of the said data collection by retrieving them from the web and centralizing them onto a single and easily accessible place. We terefore consider using a datalake wich will be placed into a resource group dedicated to the fictive project so that, at the very end, it could be easy to evaluate project cost, for cloud use at least. We also motivate the cloud base use for data retrieval and pottentially processing by the need of automatically scheduling and running these stages so that, finally, the raw data remain up to date, for instance.
For ease we will consider only a single one data lake as well as only a single one keyvault all accross this project.<br>
Thus we will need two resource groups. One to get a key vault and another one dedicated to the fictive project.
### First goal
Our first goal to meet that fictive project reuirements will be to securely deploy resources on azure without having to manually authenticate. This is the main goal of that repository actually since automatic authentication requires:
+ Understanding basis security concepts
+ Implementing service principals
When talking about resource deployment we clearly talk about:
+ A resource group
+ A datalake with one or several containers
    + As the context is a fictitious project for training purpose only, our choice for the data lake configuration, will be minimal cost driven.
+ Some service principals to securely access Azure for various task we have to do on it (Keyvault access, Subscription contribution, data lake files accesses)
We will do that with help of terraform from Hashi corp.

## Second goal
Our second goal will be to implement web scraping functions as well as  
files transfert function to move files from the web scraping machine (either a local machine or a cloud virtual machine however we wo't explore that latter track) to the data lake we deployed previously.

## Requirements
### Azure resources & services
* Three service principals each one with its own configured secret.
    + One in charge to secure keyvault access and querrying.<br>
    To do so, ensure yourself to go to the "access policies" section of the keyvault<br>
    in order to grant "get" and "set" accesses only of this service principal over the keyvault.
    You also need to give the service principal a "reader" role onto the keyvault. This is defined on "Access Control (IAM)" of the keyvault.
    + One for subscription resources management (deployment & deletion)
    + One for active directory resources management (deployment & deletion of service principals)
    + One for monitoring secure access to the data lake.
    So, once the service principal is in place, do not forget to give it a "Storage Blob Data Contributor" role.
    To do so, simply go to the datalake, under "Access control (IAM)", select "add" then the role and select the service principal. 

* An azure resource group that comprises:
    + A keyvault whose access configuration is set on "Access Policy". Securely enclose the following inside:
        + The application ID of the service principal responsible for monitoring access to the data lake
        + The secret value of the service principal responsible for monitoring access to the data lake
    
    + A datalake of "Gen2" type with one container at least. You also can create a directory within that container if you whish.

### Programming & Coding resources
* terraform
* azure-cli (so that terraform can deploy on azure)
* Python version 3.11 and following python libraries :
    + azure-identity
    + azure-keyvault-secrets
    + azure-storage-blob
    + python-dotenv
    + beautifulsoup4
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
        + `KEYVAULT_RESOURCE_GROUP_NAME= <your-main-resource-group-with-the-keyvault-to-use>`
        + `DATALAKE_NAME               = <your-datalake-name>`
        + `DATALAKE_CLIENT_ID_NAME     = <secret-name-under-which-you-enclosed-the-service-principal-application-id>`
            - The Application ID of the service principal that is responsible for securing write access to your datalake.<br>
        + `DATALAKE_CONTAINER_NAME     = <the-name-of-the-target-container-within-your-datalake>`
            - Notice that only lower case alphanumeric characters and hyphens are allowed.
        + `DATALAKE_CLIENT_SECRET_NAME = <secret-name-under-which-you-enclosed-the-service-principal-client-secret>`
            - The secret associated with the service principal for authenticating write access to your datalake.<br>`
        + `TERRAFORM_CLIENT_ID_NAME     = <secret-name-under-which-you-enclosed-the-service-principal-application-id-dedicated-to-resources-deployment-on-the-subscription>`
        + `TERRAFORM_CLIENT_SECRET_NAME = <secret-name-under-which-you-enclosed-the-service-principal-application-secret-dedicated-to-resources-deployment-on-the-subscription>`
        + `SP_DEPLOYER_CLIENT_ID_NAME     = <secret-name-under-which-you-enclosed-the-service-principal-application-id-dedicated-to-resources-deployment-on-the-azure-active-directory>`
        + `SP_DEPLOYER_CLIENT_SECRET_NAME = <secret-name-under-which-you-enclosed-the-service-principal-application-secret-dedicated-to-resources-deployment-on-azure-active_directory>`
        + `DATALAKE_CLIENT_ID_NAME_DESCRIPTION = ....`
        + `DATALAKE_CLIENT_SECRET_NAME_DESCRIPTION = ....`

While it is never mandatory to work with a virtual environment,<br>
I personally prefer to do it in order to manage python libraries & dependencies more easily and reliably with poetry.<br>
Therefore, if you also use a dependency management tool, then **DO NOT FORGET TO SET IT UP**.<br>
That also means, in case of the said tool is poetry, not to forget to run `poetry init` then `poetry install` as well.