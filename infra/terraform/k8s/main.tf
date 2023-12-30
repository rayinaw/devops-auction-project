resource "azurerm_resource_group" "main" {
    name = var.rsgname
    location = var.location
}

module "ServicePrincipal" {
    source = "./modules/ServicePrincipal"
    service_principal_name = var.service_principal_name
    depends_on = [ 
        azurerm_resource_group.main
     ]
}

data "azurerm_role_definition" "role_definition" {
  role_definition_id = "b24988ac-6180-42a0-ab88-20f7382dd24c"
}

resource "azurerm_role_assignment" "rolespn" {
    scope = "/subscriptions/d8b5467b-9f93-49a7-b03e-d5c3edad86ac"
    role_definition_id = data.azurerm_role_definition.role_definition.id
    principal_id = module.ServicePrincipal.service_principal_object_id

    depends_on = [
        module.ServicePrincipal,
    ]
}

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

resource "azurerm_key_vault_secret" "kv" {
    name         = module.ServicePrincipal.client_id
    value        = module.ServicePrincipal.client_secret
    key_vault_id = module.key_vault.keyvault_id
    depends_on = [
        module.key_vault,
        azurerm_role_assignment.rolespn
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