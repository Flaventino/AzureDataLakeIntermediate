# MODULE PURPOSE DESCRIPTION
#   This module manages access to the Azure Key Vault for retrieving and
#   storing secrets (get/set operations).

# KEY VAULT ACCESS
data "azurerm_key_vault" "Keyper"{
    name                = var.keyvaultName
    resource_group_name = var.keyvaultRgName
    }


# KEY VAULT SECRETS RETRIEVAL
data "azurerm_key_vault_secret" "KeyperSecrets" {
    # Authentication
    key_vault_id = sensitive(data.azurerm_key_vault.Keyper.id)
    # Retrieves Secrets Only If 'action' Parameter Is 'get'
    for_each     = var.action == "get" ? var.kvSecretsMap : {}
    name         = each.value[0]
    }

# KEY VAULT SECRETS CREATION
resource "azurerm_key_vault_secret" "datalake_monitor_secret" {
    # Authentication
    key_vault_id = sensitive(data.azurerm_key_vault.Keyper.id)
    # Set New Secrets Only If 'action' Parameter Is 'set'
    for_each         = var.action == "set" ? var.kvSecretsMap : {}
        name         = each.value[0]
        value        = each.value[2]
        content_type = each.value[1]
    }


# KEY VAULT SECRETS OUTPUT (only if 'action' Parameter Is 'get')
output "KeyperSecrets" {
    sensitive = true
    value     = var.action == "get" ? data.azurerm_key_vault_secret.KeyperSecrets : {}
    }