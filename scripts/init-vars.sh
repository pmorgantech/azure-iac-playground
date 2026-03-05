#!/bin/bash

set -e

export LOCATION=eastus
export COMMON_RESOURCE_GROUP_NAME=terraform-rg-common
export TF_STATE_STORAGE_ACCOUNT_NAME=satfstate6028
export TF_STATE_CONTAINER_NAME=tfstate
export KEYVAULT_NAME=terraform-kv
