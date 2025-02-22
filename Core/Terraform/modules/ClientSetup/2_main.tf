# MODULE PURPOSE DESCRIPTION
#   To replicate the process of deploying a service principal through the Azure
#   portal, this module first creates an App Registration with the client secret
#   option enabled. It then deploys a service principal and links it to the application.
#   While in the Azure portal this association happens automatically upon
#   creating the App Registration, this module explicitly performs both steps.

# APP REGISTRATION DEPLOYMENT
## Deploying the app registration
resource "azuread_application" "AppRegistration" {
  display_name = var.appRegistrationName
  }
## Creating a secret (password)
resource "azuread_application_password" "AppRegSecret" {
  display_name = "Client Secret"
  application_id = sensitive(azuread_application.AppRegistration.id)
  }

# SERVICE PRINCIPAL DEPLOYMENT
resource "azuread_service_principal" "Client" {
  client_id = sensitive(azuread_application.AppRegistration.client_id)
  }

# CLIENT CREDENTIALS OUTPUT
output "Credentials" {
  sensitive = true
  value     = {"appID" = sensitive(azuread_application.AppRegistration.id)
               "appSecret" = sensitive(azuread_application_password.AppRegSecret.value)
               "clientID" = sensitive(azuread_service_principal.Client.object_id)}
  }