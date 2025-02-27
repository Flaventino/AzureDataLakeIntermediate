# Azure Data Lake Intermediate

## Overview
This repository explores security concepts and implementations on Azure through a simple use case. The goal is to securely collect and store data in an Azure Data Lake while enforcing strong security principles such as Role-Based Access Control (RBAC) and the Principle of Least Privilege.

## Project Context
We simulate a fictional data project where a data engineer is responsible for retrieving data from the web and centralizing it in a secure Azure Data Lake. The stored data will later be used by data scientists, either immediately or after a data refinement stage (not covered in this repository). The focus is on:

- Securely deploying and managing Azure resources.
- Automating authentication using service principals.
- Implementing security best practices to minimize risks.

To achieve this, we will provision:
- A dedicated Azure Data Lake.
- A Key Vault for storing sensitive credentials.
- Multiple service principals with the least required privileges.
- A Terraform-based deployment setup for automation.

## Technical Goals
### 1. Secure Infrastructure Deployment
The first objective is to deploy the necessary Azure resources *without requiring manual authentication*. This involves:
- Understanding fundamental security concepts.
- Implementing service principals for authentication.
- Deploying infrastructure using Terraform, including:
  - A resource group.
  - An Azure Data Lake with at least one container.
  - Service principals for:
    - Key Vault access
    - Subscription-level resource management
    - Data Lake access

### 2. Automated Data Collection
The second objective is to:
- Implement Python-coded web scraping functions.
- Securely transfer collected files to the Azure Data Lake using Python scripts.

## Required Azure Resources & Services
- **Service Principals (SPs)**:
  - One for securely accessing the Key Vault (with "get" and "set" permissions under "Access policies" and a "Key Vault Reader" role under "Access control (IAM)").
  - One for managing subscription resources, requiring two roles:
    - "Contributor" for deploying resources.
    - "User Access Administrator" for granting roles to deployed service principals.<br>
       For security reasons (Least Privilege Principle), the latter role should only be defined used to grant the "Storage Blob Data Contributor" role.
  - One for managing Active Directory resources, primarily for deploying "App Registrations" and "Service Principals."<br>
    This requires the "Application Administrator" role.
- **Resource Groups**:
  - A group for the Key Vault (must exist beforehand as the Key Vault is a prerequisite).
- **Azure Key Vault**:
  - Stores secrets such as service principal credentials.

## Deployed Azure Resources & Services (Project Dedicated Azure Infrastructure)
The following Azure resources and services will be provisioned automatically by Terraform as part of the project deployment:

- **Service Principals**:
  - Only one, so far, in order to securely access the Data Lake (`Storage Blob Data Contributor` role. Required for reading and writing blobs).
- **Resource Group**: A dedicated resource group for the project's infrastructure.
- **Azure Data Lake Gen2**:
  - A Data Lake storage account.
  - A container (`raw-web-data`) for storing collected data.
  - Predefined directories for organizing different file formats.

## Setup & Dependencies
### Prerequisites
- **Terraform** (for infrastructure as code deployment)
- **Azure CLI** (for authentication and Azure interactions)
- **Python (>=3.11)** and the following libraries:
  - `azure-identity`
  - `azure-keyvault-secrets`
  - `azure-storage-blob`
  - `python-dotenv`
  - `beautifulsoup4`
- **A `.env` file** to store sensitive credentials securely:
  - Location: `<project_root>/Core/Credentials/.env`
  - Required variables:
    ```
    TENANT_ID=<your-tenant-id>
    SUBSCRIPTION_ID=<your-subscription-id>
    KEYVAULT_NAME=<your-keyvault-name>
    KEYVAULT_CLIENT_ID=<your-service-principal-client-id>
    KEYVAULT_CLIENT_SECRET=<your-service-principal-client-secret>
    KEYVAULT_RESOURCE_GROUP_NAME=<your-keyvault-resource-group>
    TERRAFORMER_CLIENT_ID_NAME=<terraform-client-id-secret-name>
    TERRAFORMER_CLIENT_SECRET_NAME=<terraform-client-secret-name>
    SP_DEPLOYER_CLIENT_ID_NAME=<sp-deployer-client-id-secret-name>
    SP_DEPLOYER_CLIENT_SECRET_NAME=<sp-deployer-client-secret-name>
    PROJECT_RESOURCE_GROUP_NAME=<your-project-resource-group>
    PROJECT_RESOURCE_GROUP_LOCATION=<your-region>
    DATALAKE_NAME=<your-datalake-name>
    DATALAKE_CLIENT_NAME=<your-datalake-client-name>
    DATALAKE_CONTAINER_NAME=<your-datalake-container-name>
    DATALAKE_DIRECTORY_NAME_FOR_FLAT_FILES=<your-flat-files-directory>
    DATALAKE_DIRECTORY_NAME_FOR_PARQUET_FILES=<your-parquet-files-directory>
    DATALAKE_CLIENT_ID_NAME=<datalake-client-id-secret-name>
    DATALAKE_CLIENT_SECRET_NAME=<datalake-client-secret-name>
    DATALAKE_CLIENT_ID_NAME_DESCRIPTION=<description>
    DATALAKE_CLIENT_SECRET_NAME_DESCRIPTION=<description>
    ```
  - Not all listed variables are strictly sensitive, but they are grouped here for consistency. This avoids using `.tfvars` files while ensuring all necessary variables are loaded and exported to Terraform.

## Project Execution
### Key Commands
- **Deploy infrastructure & run the full pipeline:**
  ```bash
  python main.py
  ```
- **Destroy deployed infrastructure:**
  ```bash
  python delete_infra.py
  ```
- **Reset Terraform state to its initial state:**
  ```bash
  ./Core/Terraform/management/.reset.sh
  ```

## Additional Notes
- This project is primarily Python-based:
  - Python scripts handle automated data collection and secure data transfer.
  - Terraform deployment commands are scheduled and orchestrated using Python.
  - Key project scripts (`main.py`, `delete_infra.py`) manage overall execution.
  - Users are encouraged to check the `management` folder inside the Terraform directory for Python-based infrastructure automation.
- Using a virtual environment is recommended for dependency management. If using Poetry, set it up with:
  ```bash
  poetry init
  poetry install
  ```

## References
For further details, check the official documentation of key libraries and services used in this project:
- [Azure Identity SDK](https://learn.microsoft.com/en-us/python/api/overview/azure/identity)
- [Azure Key Vault Secrets SDK](https://learn.microsoft.com/en-us/python/api/overview/azure/keyvault-secrets)
- [Azure Storage Blob SDK](https://learn.microsoft.com/en-us/python/api/overview/azure/storage-blob)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Python Dotenv](https://pypi.org/project/python-dotenv/)
- [BeautifulSoup4](https://www.crummy.com/software/BeautifulSoup/bs4/doc/)

---
This project serves as both an introduction to Azure security concepts and a hands-on implementation of secure data collection and storage using Terraform and Python. 🚀