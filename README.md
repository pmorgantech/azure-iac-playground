# azure-iac-playground
Various Azure stacks deployed via IaC


# Setup

This repository assumes you have a few prerequisites installed:

1. Azure CLI:

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

2. Terraform CLI: [[https://developer.hashicorp.com/terraform/install]]

3. Trufflehog: [[https://github.com/trufflesecurity/trufflehog]]

4. Pre-commit

```bash
pip install pre-commit
pre-commit install
```

## Bootstrapping Azure remote state backend

Directions are in the [[stacks/00-bootstrap/README.md]] file

