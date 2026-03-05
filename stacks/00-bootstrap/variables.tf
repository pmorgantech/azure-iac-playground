variable "location" {
  type        = string
  description = "Azure Region"
  default     = "eastus"
}

variable "terraform_admin_group_name" {
  type        = string
  description = "AD group name of terraform administrators"
  default     = "tf-admins"
}

variable "tfstate_resource_group_name" {
  type        = string
  description = "Resource Group name for terraform state"
  default     = "rg-tfstate"
}

variable "storage_account_name_prefix" {
  type        = string
  description = "Lowercase alphanum prefix for storage account used for tfstate"
  default     = "satfstate"

  # Storage account names must be < 24 characters and lowercase alphanumeric
  validation {
    condition = (
      can(regex("^[a-z0-9]+$", var.storage_account_name_prefix)) &&
      length(var.storage_account_name_prefix) <= 16 &&
      length(var.storage_account_name_prefix) >= 4
    )
    error_message = "storage_account_name_prefix must be 4-16 characters, lowercase alpha-numeric."
  }
}

variable "container_name" {
  type        = string
  description = "Blob container name for tfstate"
  default     = "tfstate"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default = {
  }
}

variable "enable_delete_lock" {
  type    = bool
  default = true
}
