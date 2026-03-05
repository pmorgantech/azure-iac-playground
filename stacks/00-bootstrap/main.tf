# Creates a terraform state setup in Azure
# Resource Group + Storage Account + Blob container + permissioning

data "azuread_client_config" "current" {}

# Create Terraform admins group and add current user to group
resource "azuread_group" "tf_admins" {
  display_name            = var.terraform_admin_group_name
  security_enabled        = true
  prevent_duplicate_names = true
}

resource "azuread_group_member" "me" {
  group_object_id  = azuread_group.tf_admins.object_id
  member_object_id = data.azuread_client_config.current.object_id
}

resource "azurerm_resource_group" "tfstate" {
  name     = var.tfstate_resource_group_name
  location = var.location
  tags     = var.tags
}

# We will use .hex which doubles the effective output length
# from 4 to 8 chars
resource "random_id" "sa_suffix" {
  byte_length = 4
}

locals {
  storage_account_name = "${var.storage_account_name_prefix}${random_id.sa_suffix.hex}"
}

resource "azurerm_storage_account" "tfstate" {
  name                            = local.storage_account_name
  location                        = azurerm_resource_group.tfstate.location
  resource_group_name             = azurerm_resource_group.tfstate.name
  account_tier                    = "Standard"
  account_replication_type        = "LRS" # Choose ZRS/GRS for corporate env
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  shared_access_key_enabled       = false
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 14
    }
    container_delete_retention_policy {
      days = 14
    }
  }
  tags = var.tags
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

# RBAC: allow listed principals to read/write blobs (state) using Entra ID auth
resource "azurerm_role_assignment" "tfstate_blob_contrib" {

  principal_id         = azuread_group.tf_admins.object_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_container.tfstate.id
}

resource "azurerm_role_assignment" "tfstate_reader" {
  principal_id         = azuread_group.tf_admins.object_id
  role_definition_name = "Reader"
  scope                = azurerm_storage_account.tfstate.id
}

# Optional: protect the state RG from accidental deletion
resource "azurerm_management_lock" "tfstate_rg_cannot_delete" {
  count = var.enable_delete_lock == true ? 1 : 0

  name       = "lock-tfstate-rg"
  scope      = azurerm_resource_group.tfstate.id
  lock_level = "CanNotDelete"
  notes      = "Locked to prevent loss of Terraform state"
}
