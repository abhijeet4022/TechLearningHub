## What is Terragrunt?

**Terragrunt** is a thin wrapper for [Terraform](https://www.terraform.io/) that helps with:

* Reusability of Terraform code using modules.
* Managing remote state configurations.
* DRY (Don't Repeat Yourself) principles by avoiding repeating common Terraform code.
* Better management of infrastructure across **multiple environments** (dev, test, prod).

It reads `terragrunt.hcl` files instead of `.tf` files and uses that to call underlying Terraform code, usually via modules.

---

## Use Case: Azure Resource Deployment Using Local Module

Assume you have an Azure Terraform module at this path:
`/terraform/modules/openai`
This directory contains reusable Terraform code to deploy Azure OpenAI resources.

You want to use **Terragrunt** to call this module from a structured path like:
`/terragrunt/azure-prod/us-primary/openai/terragrunt.hcl`
with a root configuration at:
`/terragrunt/azure-prod/us-primary/terragrunt.hcl`

---

## Updated Folder Structure Example

```
.
├── terraform
│   └── modules
│       └── openai
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
└── terragrunt
    └── azure-prod
        └── us-primary
            ├── terragrunt.hcl            # Root-level config (backend, common settings)
            └── openai
                └── terragrunt.hcl        # Component-specific config
```

---

## File: `/terragrunt/azure-prod/us-primary/terragrunt.hcl`

```hcl
remote_state {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-name"
    storage_account_name = "storage_account_name"
    container_name       = "tfstate"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
}
```

> ☁️ This stores state in an Azure Storage Account and enables shared state management.

---

## File: `/terragrunt/azure-prod/us-primary/openai/terragrunt.hcl`

```hcl
include {
  path = find_in_parent_folders()
}

locals {
  parent = "${get_terragrunt_dir()}/../"
  name   = basename(dirname(local.parent))
}

terraform {
  source = "../../../../terraform/modules/openai"
}

inputs = {
  resource_group_name = "rg-openai-prod"
  location            = "eastus"
  openai_account_name = "openai-prod-account"
}

generate "provider" {
  path      = "providers.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {
    api_management {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted         = false
    }
  }
}
EOF
}
```

---

## Explanation of Azure-Based Structure

### 📂 Root-Level: `us-primary/terragrunt.hcl`

* Defines a shared remote backend across all components under `us-primary`.
* Avoids duplicating backend config for each component like `openai`, `aks`, etc.

### 📁 Module-Level: `us-primary/openai/terragrunt.hcl`

* Inherits backend config via `include`.
* Injects Azure provider using the `generate` block.
* Points to the Terraform module `../../../../terraform/modules/openai`.
* Supplies required inputs (resource group, location, etc.).

### 🧠 Locals

* Helps dynamically generate names/identifiers based on path structure.

---

## How to Run This Setup

```bash
cd terragrunt/azure-prod/us-primary/openai
terragrunt init
terragrunt apply
```

---

## Why This Structure Works Well

* ✅ Clear environment separation: `azure-prod/us-primary`
* ✅ Common backend per region or environment
* ✅ DRY principle: shared config is inherited, not repeated
* ✅ Pluggable module: same module can be reused in other environments (e.g., dev, staging)

---

Let me know if you'd like to extend this with:

* Azure Key Vault or AKS examples
* Dynamic backend naming
* `dependency` blocks between components (e.g., VNet → OpenAI)
