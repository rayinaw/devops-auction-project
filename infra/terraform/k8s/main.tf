resource "azurerm_resource_group" "main" {
    name = var.rsgname
    location = var.location
}

data "azurerm_client_config" "current" {
  
}
// Create Service Principal
module "ServicePrincipal" {
    source = "./modules/ServicePrincipal"
    service_principal_name = var.service_principal_name
    depends_on = [ 
        azurerm_resource_group.main
    ]
}
// Set role for Service Principal
data "azurerm_role_definition" "role_definition" {
  // role_definition_id = "b24988ac-6180-42a0-ab88-20f7382dd24c" // contributor
  role_definition_id = "00482a5a-887f-4fb3-b363-3b7fe8e74483"
}

resource "azurerm_role_assignment" "rolespn" {
    scope = "/subscriptions/e34551b1-e800-461b-85df-03af83f61d5d"
    role_definition_id = data.azurerm_role_definition.role_definition.id
    principal_id = module.ServicePrincipal.service_principal_object_id

    depends_on = [
        module.ServicePrincipal,
    ]
}

// Store Service Principal secret
module "key_vault" {
    source = "./modules/keyvault"
    keyvault_name = var.keyvault_name
    location = var.location
    resource_group_name = var.rsgname
    service_principal_name = var.service_principal_name
    service_principal_object_id = module.ServicePrincipal.service_principal_object_id
    service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id

    depends_on = [ 
        module.ServicePrincipal
     ]
}

resource "azurerm_key_vault_access_policy" "kv-pol-spn" {
    key_vault_id = module.key_vault.keyvault_id
    tenant_id    = data.azurerm_client_config.current.tenant_id
    object_id    = module.ServicePrincipal.service_principal_object_id

    key_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Decrypt",
    "Encrypt",
    "UnwrapKey",
    "WrapKey",
    "Verify",
    "Sign",
    "Purge",
    "Release",
    "Rotate",
    "GetRotationPolicy",
    "SetRotationPolicy",
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Purge",
  ]
}

# resource "azurerm_key_vault_access_policy" "example" {
#     key_vault_id = module.key_vault.keyvault_id
#     tenant_id    = data.azurerm_client_config.current.tenant_id
#     object_id    = data.azurerm_client_config.current.object_id

#     key_permissions = [
#     "Get",
#     "List",
#     "Update",
#     "Create",
#     "Import",
#     "Delete",
#     "Recover",
#     "Backup",
#     "Restore",
#     "Decrypt",
#     "Encrypt",
#     "UnwrapKey",
#     "WrapKey",
#     "Verify",
#     "Sign",
#     "Purge",
#     "Release",
#     "Rotate",
#     "GetRotationPolicy",
#     "SetRotationPolicy",
#   ]

#   secret_permissions = [
#     "Get",
#     "List",
#     "Set",
#     "Delete",
#     "Recover",
#     "Backup",
#     "Restore",
#     "Purge",
#   ]
# }

resource "azurerm_key_vault_secret" "kv" {
    name         = module.ServicePrincipal.client_id
    value        = module.ServicePrincipal.client_secret
    key_vault_id = module.key_vault.keyvault_id
    depends_on = [
        module.key_vault,
    ]
}

module "aks" {
    source                 = "./modules/aks/"
    service_principal_name = var.service_principal_name
    client_id              = module.ServicePrincipal.client_id
    client_secret          = module.ServicePrincipal.client_secret
    location               = var.location
    resource_group_name    = var.rsgname

    depends_on = [
        module.ServicePrincipal
    ]
}