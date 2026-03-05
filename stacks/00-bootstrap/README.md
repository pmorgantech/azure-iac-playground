# Terraform Bootstrap (Remote State setup)

This terraform root module initializes some Azure resources for the
purpose of providing a container for remote terraform state.

To use this:

```bash
terraform init
terraform apply
```

This will perform the following actions:
- Provision a terraform admins Entra group, adding the current user to the group
- Provision a rg-tfstate resource group
- Provision a storage account and ensure sane defaults
- Provision a blob container and assign tfadmins rbac access
- Protect the RG against deletion

Upon running the bootstrap you will be left with some output which you can put into your stack root modules as `backend.hcl`:

```text
# backend.hcl
container_name = "tfstate"
resource_group_name = "rg-tfstate"
storage_account_name = "satfstatedcd91c28"
use_azuread_auth = true
```

You will need to add a line to specify the key name - keep this in line with the stack name for simplicity.

For example, in the 00-bootstrap dir, you can add the key as:
```bash
key = "bootstrap.tfstate"
```

Then re-initialize the module to upload the state to Azure blob:

```bash
terraform init -backend-config=backend.hcl -migrate-state
```

