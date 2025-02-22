# DEFINITION OF TERRAFORM SETTINGS
# Although it is a good practice, declaring settings and providers is not mandatory.
# Except when we have to deal we multiple provider like this project (see root module)
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
      }
    }
  }